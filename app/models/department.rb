class Department < ApplicationRecord

  has_many :user_departments, dependent: :destroy
  has_many :users, through: :user_departments
  has_many :posts
  has_many :unreads
  has_many :inspection_rooms, dependent: :destroy

end
