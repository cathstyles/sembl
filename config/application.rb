require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(:default, Rails.env)

module Sembl
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join("lib")
    config.autoload_paths << Rails.root.join("app/responders")

    config.time_zone = "Melbourne"

    config.i18n.enforce_available_locales = true

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
