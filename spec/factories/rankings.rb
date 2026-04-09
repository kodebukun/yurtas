FactoryBot.define do
  factory :ranking do
    rank { 1 }
    association :user
  end
end
