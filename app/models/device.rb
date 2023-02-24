class Device < ApplicationRecord

  validates :name, {presence: true}
  validates :os, {presence: true}
  validates :security_soft_id, {presence: true}
  validates :user_id, {presence: true}
  validates :device_type, {presence: true}

  belongs_to :security_soft, optional: true
  belongs_to :user, optional: true
end
