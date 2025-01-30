if ENV['CLOUDINARY_URL'].present? && Rails.env.production?
  require 'cloudinary'

  CarrierWave.configure do |config|
    config.storage = :cloudinary
    config.cloudinary_access_url = true
    config.cloudinary_cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
    config.cloudinary_api_key = ENV['CLOUDINARY_API_KEY']
    config.cloudinary_api_secret = ENV['CLOUDINARY_API_SECRET']
  end
end
