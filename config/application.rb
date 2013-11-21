require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(:default, Rails.env)

# Load the deployment specific config into environment variables
if File.exist?(config_file = File.expand_path("../../config/config.yml", __FILE__))
  YAML.load_file(config_file).each do |key, value|
    ENV[key.to_s] = value
  end
end

module Sembl
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join("lib")

    config.time_zone = "Melbourne"

    config.assets.precompile += %w(admin.css admin.js)

    config.generators do |g|
      g.hidden_namespaces += [:test_unit, :erb]

      g.template_engine :slim
      g.javascript_engine :coffee
      g.stylesheet_engine :sass
      g.test_framework :rspec
      g.fixture_replacement :factory_girl
    end
  end
end
