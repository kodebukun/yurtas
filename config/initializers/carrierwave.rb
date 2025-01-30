require 'carrierwave/storage/cloudinary'

CarrierWave.configure do |config|
  config.storage = :cloudinary
  config.cloudinary_url = "cloudinary://#{ENV['CLOUDINARY_API_KEY']}:#{ENV['CLOUDINARY_API_SECRET']}@#{ENV['CLOUDINARY_CLOUD_NAME']}"
end
