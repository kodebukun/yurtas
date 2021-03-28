class Material < ApplicationRecord
  validates :name, presence: true
  validates :material_type, presence: true
  validates :department_id, presence: true
  validates :image, presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 0..1.megabytes }

  has_one_attached :image
  belongs_to :manufacturer
end
