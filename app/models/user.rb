class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: 30}
  validates :login_id, presence: true, uniqueness: true
  validates :password, confirmation: true

  has_secure_password

  has_many :user_works, dependent: :destroy
  has_many :works, through: :user_works
  has_many :user_positions, dependent: :destroy
  has_many :positions, through: :user_positions
  has_many :user_departments, dependent: :destroy
  has_many :departments, through: :user_departments


end