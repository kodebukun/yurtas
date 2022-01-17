FactoryBot.define do
  factory :diary do
    title { "MyString" }
    content { "MyText" }
    user_id { 1 }
    partner_id { 1 }
  end
end
