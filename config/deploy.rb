set :application, 'designcrit.io'
server 'designcrit.io', :app, :web, :db, :assets, primary: true
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

namespace :deploy do
  namespace :assets do
    desc 'install asset dependencies'
    task :install, roles: [:assets] do
      run "cd #{latest_release} && bower install --no-color"
    end
  end
end


after 'deploy', 'deploy:migrate'
after 'deploy', 'deploy:cleanup'
after 'deploy:restart', 'unicorn:restart'
after 'deploy:stop', 'delayed_job:stop'
after 'deploy:start', 'delayed_job:start'
after 'deploy:restart', 'delayed_job:restart'
before 'deploy:assets:precompile', 'deploy:assets:install'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

require 'bundler/capistrano'
require 'rvm/capistrano'
require 'capistrano-unicorn'
require 'capistrano_colors'
require 'delayed/recipes'