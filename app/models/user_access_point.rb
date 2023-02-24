class UserAccessPoint < ApplicationRecord

  validates :user_id, {presence: true}
  validates :access_point_id, {presence: true}


  belongs_to :user
  belongs_to :access_point

end
