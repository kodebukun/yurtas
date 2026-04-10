FactoryBot.define do
  factory :work do
    name { "テスト係り" }
    display_name { nil }

    trait :with_display_name do
      name { "飯田地区事業場安全衛生" }
      display_name { "事業場安全衛生" }
    end
  end
end
