FactoryBot.define do
  factory :post do
    title { "MyString" }
    content { "MyText" }
    user_id { 1 }
    work_id { 1 }
    department_id { 1 }
    meeting { false }
  end
end
