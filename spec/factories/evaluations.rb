FactoryBot.define do
  factory :evaluation do
    user_id { 1 }
    anonymous_post_id { 1 }
    agreement { false }
  end
end
