FactoryBot.define do
  factory :breach do
    content { "MyText" }
    user_id { 1 }
    anonymous_post_id { 1 }
    anonymous_comment_id { 1 }
    approval { false }
  end
end
