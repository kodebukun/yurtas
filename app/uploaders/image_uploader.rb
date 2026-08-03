class ImageUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  # 許可するファイル形式
  def extension_allowlist
    %w[jpg jpeg gif png pdf]
  end


  # ファイルサイズの上限（Imageモデル側のバリデーションで使用）
  MAX_FILESIZE = 10.megabytes

  #アップロード時に画像をリサイズ＆圧縮
  #process convert: 'jpg', if: :is_image?
  #process resize_to_fit: [800, 800], if: :is_image?
  #process quality: 80, if: :is_image?

  # デフォルト画像
  # def default_url(*args)
    # "/images/fallback/" + [version_name, "default.jpg"].compact.join('_')
  # end


end
