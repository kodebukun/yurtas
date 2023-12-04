FactoryBot.define do
  factory :incident do
    type { "" }
    place { "MyString" }
    years { 1 }
    target { "MyString" }
    happened { "MyString" }
    response { "MyText" }
    measure { "MyText" }
    excuse { "MyText" }
  end
end
