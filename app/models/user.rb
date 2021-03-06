class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: 30}
  validates :login_id, presence: true, uniqueness: true
  validates :password, confirmation: true
  validates :comment, length: {maximum: 30}

  has_secure_password

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  has_many :user_works, dependent: :destroy
  has_many :works, through: :user_works
  has_many :user_positions, dependent: :destroy
  has_many :positions, through: :user_positions
  has_many :user_departments, dependent: :destroy
  has_many :departments, through: :user_departments
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :mornings
  has_one :ranking

end
