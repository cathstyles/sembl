Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
  config.use_ssl = true
  config.notify_release_stages = ['production', 'staging']
  config.release_stage = ENV['STAGE']
end
