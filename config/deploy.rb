set :application, 'designcrit.io'
server '23.253.52.105', :app, :web, :db, :assets, primary: true
set :branch, :master
set :rails_env, 'production'
set :unicorn_env, 'production'
set :app_env, 'production'
set :deploy_to, '/var/www/designcrit.io'
set :current_path, File.join(deploy_to, current_dir)
set :unicorn_pid, File.join(current_path, 'tmp/pids/unicorn.pid')
set :repository, 'git@github.com:amir20/mydesigncrit.com.git'
set :scm, :git
set :deploy_via, :remote_cache
set :use_sudo, false
set :stages, %w(production)
set :default_stage, 'production'
set :delayed_job_command, 'bin/delayed_job'
set :rvm_type, :system
set :delayed_job_args, '-n 1'

namespace :deploy do
  namespace :assets do
    desc 'install asset dependencies'
    task :install, roles: [:assets] do
      run "cd #{latest_release} && bower install --no-color"
    end
  end
end


namespace :bluepill do
  desc 'Stop processes that bluepill is monitoring and quit bluepill'
  task :quit, :roles => [:app] do
    run "cd #{current_path} && bundle exec bluepill --no-privilege stop"
    run "cd #{current_path} && bundle exec bluepill --no-privilege quit"
  end

  desc 'Load bluepill configuration and start it'
  task :start, :roles => [:app] do
    run "cd #{current_path} && bundle exec bluepill --no-privilege load /var/www/designcrit.io/current/config/bluepill/production.pill"
  end

  desc 'Prints bluepills monitored processes statuses'
  task :status, :roles => [:app] do
    run "cd #{current_path} && bundle exec bluepill --no-privilege status"
  end
end


after 'deploy', 'deploy:migrate'
after 'deploy', 'deploy:cleanup'
after 'deploy:restart', 'unicorn:restart'

# after 'deploy:stop', 'delayed_job:stop'
# after 'deploy:start', 'delayed_job:start'
# after 'deploy:restart', 'delayed_job:restart'

after 'deploy:update', 'bluepill:quit', 'bluepill:start'
before 'deploy:assets:precompile', 'deploy:assets:install'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

require 'bundler/capistrano'
require 'rvm/capistrano'
require 'capistrano-unicorn'
require 'capistrano_colors'
require 'delayed/recipes'