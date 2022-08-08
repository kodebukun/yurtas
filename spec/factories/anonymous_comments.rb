FactoryBot.define do
  factory :anonymous_comment do
    content { "MyText" }
    user_id { 1 }
    anonymous_post_id { 1 }
    breach { false }
    nickname { "MyString" }
    position { "MyString" }
  end
end
