# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version")

gem "rails", "~> 7.0.3"

gem "pg"

gem "bootsnap", require: false
gem "puma"

gem "terser"

gem "coffee-rails"
gem "hamlit"
gem "sassc-rails"

gem "jquery-rails"
gem "turbolinks"

gem "bootstrap", "~> 4.3"
gem "bootstrap4-datetime-picker-rails"
gem "font-awesome-rails"
gem "highcharts-rails"
gem "momentjs-rails"

gem "acts-as-taggable-on"
gem "groupdate"
gem "kramdown"

gem "rollbar"

group :development do
  gem "listen"

  gem "better_errors"
  gem "binding_of_caller"
  gem "web-console"

  gem "reek", require: false

  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-thread_safety", require: false
end

group :development, :test do
  gem "rspec-activemodel-mocks"
  gem "rspec-rails"

  gem "capybara"
  gem "webdrivers", require: false
end

group :test do
  gem "factory_bot_rails"

  gem "simplecov", require: false
end

gem "hirb"
gem "pry-rails"

gem "next_rails", group: :development
