CarrierWave.configure do |config|
  config.cache_storage = :file # 開発環境のキャッシュ保存

  if Rails.env.production?
    config.storage = :cloudinary
    config.cloudinary_credentials = {
      cloud_name: ENV['CLOUDINARY_CLOUD_NAME'],
      api_key:    ENV['CLOUDINARY_API_KEY'],
      api_secret: ENV['CLOUDINARY_API_SECRET']
    }
    config.asset_host = ENV['CLOUDINARY_ASSET_HOST'] # 必要なら指定
  else
    config.storage = :file
  end
end
