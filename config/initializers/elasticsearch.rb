if ENV['BONSAI_URL']
  ENV['ELASTICSEARCH_URL'] = ENV['BONSAI_URL']
end

Rails.application.config.elasticsearch = {
  log: true,
  host: ENV['ELASTICSEARCH_URL']
}
