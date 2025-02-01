require_relative 'boot'

require 'rails/all'
require 'carrierwave/orm/activerecord'
require 'cloudinary'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Yurtas
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.time_zone = 'Tokyo' #追記
    config.active_record.default_timezone = :local #追記
    #フォームエラー表示時のfield_with_errorsによるレイアウト崩れ防止
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
