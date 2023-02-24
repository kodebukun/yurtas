FactoryBot.define do
  factory :access_point do
    ssid { "MyString" }
    inspection_room_id { 1 }
    password { "MyString" }
  end
end
