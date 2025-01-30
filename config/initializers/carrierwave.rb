CarrierWave.configure do |config|
  config.cloudinary_credentials = {
    cloud_name: ENV['CLOUDINARY_CLOUD_NAME'], # CloudinaryのCloud Name
    api_key: ENV['CLOUDINARY_API_KEY'],      # CloudinaryのAPIキー
    api_secret: ENV['CLOUDINARY_API_SECRET'] # CloudinaryのAPIシークレット
  }

  # ストレージの設定
  config.cache_storage = :file # 一時ファイルの保存方法
  config.storage = :cloudinary # Cloudinaryをストレージとして使用
end
