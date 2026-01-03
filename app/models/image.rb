class Image < ApplicationRecord
  belongs_to :post
  #belongs_to :dependent

  # CarrierWave の設定
  mount_uploader :image, ImageUploader

  # ファイル種別を判別するためのロジック
  before_save :set_file_type
  before_save :set_original_filename

  private

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
