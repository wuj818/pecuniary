source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version')

gem 'rails', '~> 7.0.0'

gem 'pg'

gem 'bootsnap', require: false
gem 'puma'

gem 'coffee-rails', '~> 4.2'
gem 'hamlit'
gem 'sassc-rails'

gem 'jquery-rails'
gem 'turbolinks', '~> 5.2'
gem 'terser'

gem 'bootstrap', '~> 4.3.1'
gem 'bootstrap4-datetime-picker-rails', '~> 0.3'
gem 'font-awesome-rails'
gem 'highcharts-rails', '~> 6.0'
gem 'momentjs-rails', '~> 2.20'

gem 'acts-as-taggable-on'
gem 'groupdate', '~> 4.1'
gem 'kramdown'

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
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-thread_safety', require: false
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

  gem 'simplecov', require: false
end

gem 'awesome_print'
gem 'hirb'
gem 'pry-byebug'
gem 'pry-rails'

gem 'next_rails', group: :development
