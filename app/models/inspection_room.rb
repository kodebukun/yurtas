class InspectionRoom < ApplicationRecord
  has_many :access_points, dependent: :destroy

  belongs_to :department
end
