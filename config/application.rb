require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pecuniary
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = 'Eastern Time (US & Canada)'

    config.action_view.field_error_proc = proc { |html_tag, _instance| html_tag }

    if ENV['HTTP_AUTH'].present?
      config.middleware.use(Rack::Auth::Basic) do |username, password|
        ENV['HTTP_AUTH'].split(':') == [username, password]
      end
    end
  end
end
