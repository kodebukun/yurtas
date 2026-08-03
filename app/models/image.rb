class Image < ApplicationRecord
  belongs_to :post, optional: true
  belongs_to :department, optional: true
  belongs_to :work, optional: true

  # CarrierWave の設定
  mount_uploader :image, ImageUploader

  # ファイルサイズの上限チェック
  validate :image_size_within_limit

  # ファイル種別を判別するためのロジック
  before_save :set_file_type
  before_save :set_original_filename

  private

  def image_size_within_limit
    return unless image.file
    if image.file.size > ImageUploader::MAX_FILESIZE
      errors.add(:image, "のファイルサイズは#{ImageUploader::MAX_FILESIZE / 1.megabyte}MB以下にしてください。")
    end
  end

  def set_file_type
    if image.content_type.start_with?('image')
      self.file_type = 'image'
    elsif image.content_type == 'application/pdf'
      self.file_type = 'pdf'
    else
      self.file_type = 'unknown'
    end
  end

  def set_original_filename
    if image.file.respond_to?(:original_filename)
      self.file_name = image.file.original_filename
    end
  end

end
