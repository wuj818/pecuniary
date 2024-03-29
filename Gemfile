# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version")

gem "rails", "~> 7.0.4"

gem "dotenv-rails"

gem "pg"

gem "bootsnap", require: false
gem "puma"

gem "dalli"

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

gem "honeybadger"
gem "rollbar"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "web-console"

  gem "brakeman", require: false

  gem "reek", require: false

  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-thread_safety", require: false
end

group :development, :test do
  gem "rspec-rails"

  gem "capybara"
  gem "webdrivers", require: false
end

group :test do
  gem "factory_bot_rails"

  gem "rspec_junit_formatter"
  gem "simplecov", require: false
end

gem "hirb"
gem "pry-rails"

gem "next_rails", group: :development
