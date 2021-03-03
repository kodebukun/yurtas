class Comment < ApplicationRecord
  validates :content, {presence: true}
  validates :user_id, {presence: true}

  has_many :likes, dependent: :destroy

  belongs_to :user
  belongs_to :post, optional: true
  belongs_to :morning, optional: true

end
