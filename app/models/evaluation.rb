class Evaluation < ApplicationRecord

  validates :user_id, {presence: true}
  
  belongs_to :user
  belongs_to :anonymous_post
end
