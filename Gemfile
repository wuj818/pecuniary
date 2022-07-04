source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version')

gem 'rails', '~> 5.2.8'

gem 'pg'

gem 'bootsnap', require: false
gem 'puma'

gem 'coffee-rails', '~> 4.2'
gem 'hamlit', '~> 2.9'
gem 'sass-rails', '~> 5.0'

gem 'jquery-rails', '~> 4.5'
gem 'turbolinks', '~> 5.2'
gem 'uglifier', '~> 4.1'

gem 'bootstrap', '~> 4.3.1'
gem 'bootstrap4-datetime-picker-rails', '~> 0.3'
gem 'font-awesome-rails', '~> 4.7.0'
gem 'highcharts-rails', '~> 6.0'
gem 'momentjs-rails', '~> 2.20'

gem 'acts-as-taggable-on', '~> 6.0'
gem 'groupdate', '~> 4.1'
gem 'kramdown', '~> 2.1'

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'web-console'

  gem 'spring-commands-rspec'

  gem 'haml_lint', require: false
  gem 'rubocop', require: false
  gem 'spring-commands-rubocop'
end

group :development, :test do
  gem 'rspec-activemodel-mocks'
  gem 'rspec-rails'

  gem 'capybara'
  gem 'webdrivers', require: false
end

group :test do
  gem 'factory_bot_rails'
end

gem 'awesome_print'
gem 'hirb'
gem 'pry-byebug'
gem 'pry-rails'
