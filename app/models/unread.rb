class Unread < ApplicationRecord

  validates :user_id, {presence: true}

  belongs_to :user
  belongs_to :post, optional: true
  belongs_to :anonymous_post, optional: true
  belongs_to :department, optional: true
  belongs_to :work, optional: true
  belongs_to :comment, optional: true
  belongs_to :incident, optional: true

end
