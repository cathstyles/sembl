if ENV['BOXEN_SOCKET_DIR']
  bind "unix://#{ENV['BOXEN_SOCKET_DIR']}/sembl"
  workers 1
end

if ENV['RACK_ENV'] == 'production'
  db_pool      = 5 # ENV['DB_POOL']
  db_reap_freq = 10 # ENV['DB_REAP_FREQ']

  environment 'production'
  threads 4, 4 # threads_min, threads_max = 4 # db_pool - 1

  workers 3
  preload_app!

  on_worker_boot do
    ActiveRecord::Base.connection_pool.disconnect!

    ActiveSupport.on_load(:active_record) do
      config = Rails.application.config.database_configuration[Rails.env]
      config['reaping_frequency'] = db_reap_freq
      config['pool']              = db_pool
      ActiveRecord::Base.establish_connection
    end
  end
end
