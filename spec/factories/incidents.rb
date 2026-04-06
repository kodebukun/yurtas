FactoryBot.define do
  factory :incident do
    shift { "日勤" }
    occurred_at { Time.current }
    title { "テストインシデント" }
    place { "検査室" }
    years { 1 }
    target { "患者" }
    happened { "テストの発生内容" }
    excuse { "テストの経緯" }
    association :user
    association :department
  end
end
