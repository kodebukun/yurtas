require 'cloudinary'
require 'cloudinary/carrier_wave'

CarrierWave.configure do |config|
  config.storage = :file # 開発環境ではローカルストレージを使用
  if Rails.env.production?
    config.storage = :cloudinary # 本番環境ではCloudinaryを使用
    config.cloudinary_config = {
      cloud_name: ENV['CLOUDINARY_CLOUD_NAME'], # 環境変数から設定
      api_key: ENV['CLOUDINARY_API_KEY'],
      api_secret: ENV['CLOUDINARY_API_SECRET']
    }
  end
end
