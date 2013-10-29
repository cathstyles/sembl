source "https://rubygems.org"

ruby "2.0.0"

gem "rails", "4.0.0"

gem "pg"

gem "carrierwave"
gem "decent_exposure"
gem "devise"
gem "nestive"
gem "slim-rails"
gem "simple_form"
gem "cancan"
gem "state_machine"

group :development do 
  gem "annotate"
  gem "unicorn"
  gem "better_errors", ">= 1.0.0.rc1"
  gem "binding_of_caller"
end 

group :development, :test, :assets do
  gem "jquery-rails"
  gem "sass-rails"
  gem "coffee-rails"
  gem "uglifier"
  gem "bootstrap-sass"
end

group :doc do
  gem "sdoc", require: false
end

group :development, :test do
  gem "rspec-rails"
  gem "factory_girl_rails"  
  gem "pry-rails"
end

group :test do
  gem "forgery"
  gem "shoulda-matchers"
  gem "capybara"
  gem "poltergeist"
  gem "database_cleaner"
end
