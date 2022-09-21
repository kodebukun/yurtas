FactoryBot.define do
  factory :unread do
    user_id { 1 }
    post_id { 1 }
    anonymous_post_id { 1 }
  end
end
