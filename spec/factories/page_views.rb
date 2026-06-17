FactoryBot.define do
  factory :page_view do
    association :user
    page { "home" }
  end
end
