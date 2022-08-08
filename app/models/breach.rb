class Breach < ApplicationRecord

  belongs_to :user
  belongs_to :anonymous_post, optional: true
  belongs_to :anonymous_comment, optional: true

end
