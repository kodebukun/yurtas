FactoryBot.define do
  factory :anonymous_post do
    title { "MyString" }
    content { "MyText" }
    user_id { 1 }
    breach { false }
    resolved { false }
  end
end
