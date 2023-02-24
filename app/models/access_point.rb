class AccessPoint < ApplicationRecord

  validates :ssid, {presence: true}
  validates :password, {presence: true}
  validates :inspection_room_id, {presence: true}

  has_many :user_access_points, dependent: :destroy
  has_many :users, through: :user_access_points

  belongs_to :inspection_room
end
