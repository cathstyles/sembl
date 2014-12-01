ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "rspec/autorun"
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.asset_host = "http://localhost:3000/"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

require 'transloadit/rspec/helpers'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include FeatureHelpers, type: :feature

  config.after(:all) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {js_errors: false, inspector: true})
end

# put logic in this file or initializer/carrierwave.rb
if defined?(CarrierWave)
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
    klass.class_eval do
      def cache_dir
        "#{Rails.root}/public/uploads/tmp"
      end

      def store_dir
        "#{Rails.root}/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end
end
