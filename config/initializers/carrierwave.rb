require 'carrierwave'
require 'cloudinary'
require 'cloudinary/carrier_wave'

CarrierWave.configure do |config|
  # 環境変数を使用してCloudinaryの設定を行う
  if Rails.env.production?
    config.storage = :cloudinary
    config.cloudinary_config = {
      cloud_name: ENV['CLOUDINARY_CLOUD_NAME'],
      api_key: ENV['CLOUDINARY_API_KEY'],
      api_secret: ENV['CLOUDINARY_API_SECRET']
    }
  else
    # 開発環境ではローカルストレージを使用
    config.storage = :file
  end
end
