FactoryBot.define do
  factory :post do
    title { "テスト投稿" }
    content { "テスト本文" }
    association :user
  end
end
