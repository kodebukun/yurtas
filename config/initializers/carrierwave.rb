require 'cloudinary'
require 'carrierwave'

CarrierWave.configure do |config|
  config.storage = :cloudinary
  config.cloudinary = {
    cloud_name: ENV['CLOUDINARY_CLOUD_NAME'],
    api_key: ENV['CLOUDINARY_API_KEY'],
    api_secret: ENV['CLOUDINARY_API_SECRET']
  }
end
