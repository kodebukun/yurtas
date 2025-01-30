if ENV['CLOUDINARY_URL'].present? && Rails.env.production?
  require 'cloudinary'

  CarrierWave.configure do |config|
    config.cache_storage = :file # ローカルキャッシュ
    config.fog_provider = 'fog/cloudinary' # Cloudinaryを利用
    config.fog_credentials = {
      provider: 'Cloudinary',
      cloud_name: ENV['CLOUDINARY_CLOUD_NAME'], # 環境変数から取得
      api_key: ENV['CLOUDINARY_API_KEY'],
      api_secret: ENV['CLOUDINARY_API_SECRET']
    }
    config.fog_directory = ENV['CLOUDINARY_DIRECTORY'] if ENV['CLOUDINARY_DIRECTORY']
  end
end
