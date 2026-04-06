FactoryBot.define do
  factory :user do
    sequence(:login_id) { |n| n }
    sequence(:email) { |n| "user#{n}@example.com" }
    name { "テストユーザー" }
    password { "password" }
    password_confirmation { "password" }

    after(:build) do |user|
      if user.position_ids.blank?
        position = FactoryBot.create(:position)
        user.position_ids = [position.id]
      end
    end
  end
end
