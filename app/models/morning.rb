class Morning < ApplicationRecord
  validates :title, {presence: true, length: {maximum: 140}}
  validates :content, {presence: true}
  validates :user_id, {presence: true}

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  belongs_to :user

end
