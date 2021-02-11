class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: 30}
  validates :login_id, presence: true, uniqueness: true
  validates :password, presence: true

  has_secure_password

end
