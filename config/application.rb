require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module DesigncritIo
  class Application < Rails::Application
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.sass.preferred_syntax = :sass
    config.exceptions_app = routes
    config.active_record.raise_in_transactional_callbacks = true

    ActionMailer::Base.smtp_settings = {
      user_name: 'amirraminfar',
      password: '2229lovedale',
      domain: 'designcrit.io',
      address: 'smtp.sendgrid.net',
      port: 587,
      authentication: :plain,
      enable_starttls_auto: true
    }
  end
end
