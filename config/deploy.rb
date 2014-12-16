set :application, 'designcrit'
server '162.243.155.204', :app, :web, :db, :assets, primary: true
set :branch, :master
set :rails_env, 'production'
set :app_env, 'production'
set :deploy_to, '/var/www/designcrit.io'
set :current_path, File.join(deploy_to, current_dir)
set :repository, 'git@github.com:amir20/mydesigncrit.com.git'
set :scm, :git
set :deploy_via, :remote_cache
set :use_sudo, false
set :stages, %w(production)
set :default_stage, 'production'
set :rvm_type, :system
set :default_environment,  'rvmsudo_secure_path' => 0

namespace :deploy do
  namespace :assets do
    desc 'install asset dependencies'
    task :install, roles: [:assets] do
      run "cd #{latest_release} && bower install --no-color"
    end
  end
end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, roles: :app do
    run "cd #{current_path} && rvmsudo bundle exec foreman export upstart /etc/init -a #{application} -l /var/log/#{application} -u amirraminfar -e .env"
  end

  desc 'Start the application services'
  task :start, roles: :app do
    sudo "start #{application}"
  end

  desc 'Stop the application services'
  task :stop, roles: :app do
    sudo "stop #{application}"
  end

  desc 'Restart the application services'
  task :restart, roles: :app do
    run "sudo restart #{application} || sudo start #{application}"
  end
end

namespace :logs do
  desc 'tails log files'
  task :tail, roles: :app do
    trap('INT') { exit 0 }
    run "tail -f #{shared_path}/log/production.log" do |_channel, stream, data|
      puts data
      break if stream == :err
    end
  end
end

before 'deploy:assets:precompile', 'deploy:assets:install'

after 'deploy', 'deploy:migrate'
after 'deploy', 'deploy:cleanup'
after 'deploy:update', 'foreman:export'
after 'deploy:update', 'foreman:restart'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

require 'bundler/capistrano'
require 'rvm/capistrano'
require 'capistrano_colors'
