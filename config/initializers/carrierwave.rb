require 'cloudinary'
require 'cloudinary/carrier_wave'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :cloudinary
    config.cache_storage = :file
    config.cloudinary_credentials = {
      cloud_name: ENV['CLOUDINARY_CLOUD_NAME'],
      api_key: ENV['CLOUDINARY_API_KEY'],
      api_secret: ENV['CLOUDINARY_API_SECRET']
    }
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
