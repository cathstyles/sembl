listen_address = if ENV["RACK_ENV"] == "development" && ENV["BOXEN_SOCKET_DIR"].to_s != ""
  ENV["BOXEN_SOCKET_DIR"] + "/sembl"
else
  ENV["PORT"]
end

listen listen_address, backlog: Integer(ENV["UNICORN_BACKLOG"] || 16)
worker_processes Integer(ENV["UNICORN_WORKERS"] || 3)
timeout          30
preload_app      true

before_fork do |server, worker|
  Signal.trap "TERM" do
    puts "Unicorn master intercepting TERM and sending myself QUIT instead."
    Process.kill "QUIT", Process.pid
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |server, worker|
  Signal.trap "TERM" do
    puts "Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT."
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  # Enable Que worker threads in-process (thereby avoiding a separate
  # dedicated worker process).
  Que.mode = :async
end
