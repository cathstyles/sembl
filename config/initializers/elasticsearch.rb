if ENV['BONSAI_URL']
  ENV['ELASTICSEARCH_URL'] = ENV['BONSAI_URL']
end

Rails.application.config.elasticsearch = {
  log: false,
  host: ENV['ELASTICSEARCH_URL']
}
