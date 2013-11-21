# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

if File.exists?(File.expand_path('../../.env', __FILE__))
  require 'dotenv'
  Dotenv.load
end
