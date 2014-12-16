# Set your full path to application.
app_path = File.expand_path(File.dirname(File.dirname(File.dirname(__FILE__))))

# Set unicorn options
worker_processes 2
preload_app true
timeout 180
listen '/tmp/designcrit.socket', backlog: 64

# Fill path to your app
working_directory app_path

# Log everything to one file
stderr_path 'log/unicorn.log'
stdout_path 'log/unicorn.log'

# Set master PID location
pid "#{app_path}/tmp/pids/unicorn.pid"

before_fork do |server, _worker|
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |_server, _worker|
  ActiveRecord::Base.establish_connection
end
