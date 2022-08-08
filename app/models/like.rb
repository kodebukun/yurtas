class Like < ApplicationRecord
  validates :user_id, {presence: true}

  belongs_to :user
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
  belongs_to :morning, optional: true
  belongs_to :diary, optional: true
  belongs_to :anonymous_comment, optional: true

end
