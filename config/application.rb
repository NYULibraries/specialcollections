require File.expand_path('../boot', __FILE__)

require 'rails/all'

unless Rails.env.test? || ENV['DOCKER']
  require 'figs'
  Figs.load(stage: Rails.env)
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Findingaids
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Autoload the lib path
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # output rails logs to unicorn; thanks to https://gist.github.com/soultech67/67cf623b3fbc732291a2
    unless Rails.env.test?
      config.unicorn_logger = Logger.new(STDOUT)
      config.unicorn_logger.formatter = Logger::Formatter.new
      config.logger = ActiveSupport::TaggedLogging.new(config.unicorn_logger)

      config.logger.level = Logger.const_get('INFO')
      config.log_level = :info
    end
  end
end

Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
end
