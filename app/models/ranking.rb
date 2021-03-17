class Ranking < ApplicationRecord
  validates :rank, presence: true
  validates :user_id, presence: true, uniqueness: true

  belongs_to :user

end
