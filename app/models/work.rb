class Work < ApplicationRecord

  has_many :user_works, dependent: :destroy
  has_many :users, through: :user_works
  has_many :posts
  has_many :unreads

end
