if ENV['RACK_ENV'] == 'development'
  worker_processes 1
  listen "#{ENV['BOXEN_SOCKET_DIR']}/sembl", :backlog => 1024
  timeout 120

  after_fork do |server, worker|
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end


else
  worker_processes 3
  timeout 30
  preload_app true

  before_fork do |server, worker|
    if defined?(ActiveRecord::Base)
      ActiveRecord::Base.connection.disconnect!
    end

    sleep 1
  end

  after_fork do |server, worker|
    if defined?(ActiveRecord::Base)
      ActiveRecord::Base.establish_connection
    end

    # We don't need to set the redis URL here because this unicorn config is only
    # for Heroku, where we use redistogo, and Sidekiq picks that up automatically.
    # if defined?(Sidekiq)
    #   redis_url = if ENV["REDIS_URL"].present?
    #     ENV["REDIS_URL"]
    #   elsif ENV["REDISCLOUD_URL"].present?
    #     ENV["REDISCLOUD_URL"]
    #   elsif ENV['BOXEN_REDIS_URL'].present?
    #     ENV['BOXEN_REDIS_URL']
    #   else
    #     "unix:///tmp/redis-youcamp.sock"
    #   end

    #   Sidekiq.configure_client do |config|
    #     config.redis = {url: redis_url, namespace: "sidekiq"}
    #   end
    # end
  end
end