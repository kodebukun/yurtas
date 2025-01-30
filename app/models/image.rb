class Image < ApplicationRecord
  belongs_to :post

  # CarrierWave の設定
  mount_uploader :image, ImageUploader

  # ファイル種別を判別するためのロジック
  before_save :set_file_type


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
end
