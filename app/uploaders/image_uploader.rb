class ImageUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  # 許可するファイル形式
  def extension_allowlist
    %w[jpg jpeg gif png pdf]
  end

  # ファイルサイズの上限（必要に応じて追加）
  # process :validate_max_size
  # MAX_FILESIZE = 5.megabytes
  # def validate_max_size
  #   raise CarrierWave::IntegrityError, "ファイルサイズは#{MAX_FILESIZE / 1.megabyte}MB以下にしてください。" if file.size > MAX_FILESIZE
  # end

  #アップロード時に画像をリサイズ＆圧縮
  #process convert: 'jpg', if: :is_image?
  #process resize_to_fit: [800, 800], if: :is_image?
  #process quality: 80, if: :is_image?

  # デフォルト画像
  # def default_url(*args)
    # "/images/fallback/" + [version_name, "default.jpg"].compact.join('_')
  # end


end
