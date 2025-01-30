require 'cloudinary'
require 'cloudinary/carrier_wave'



if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :cloudinary
    config.cache_storage = :file

    config.cloudinary_credentials = {
      cloud_name: ENV['CLOUDINARY_CLOUD_NAME'],
      api_key: ENV['CLOUDINARY_API_KEY'],
      api_secret: ENV['CLOUDINARY_API_SECRET']
    }
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
