#user_id=4:鈴木幸司 position_id=1:診療放射線技師長
UserPosition.seed do |s|
  s.id = 1
  s.user_id = 4
  s.position_id = 1
end

#user_id=5,6:佐藤俊光、大沼千津 position_id=2:診療放射線技師副技師長
UserPosition.seed do |s|
  s.id = 2
  s.user_id = 5
  s.position_id = 2
end

UserPosition.seed do |s|
  s.id = 3
  s.user_id = 6
  s.position_id = 2
end

#user_id=7-12:吉岡、水谷、石井、芳賀、山澤、信夫 position_id=3:主任診療放射線技師
UserPosition.seed do |s|
  s.id = 4
  s.user_id = 7
  s.position_id = 3
end

UserPosition.seed do |s|
  s.id = 5
  s.user_id = 8
  s.position_id = 3
end

UserPosition.seed do |s|
  s.id = 6
  s.user_id = 9
  s.position_id = 3
end

UserPosition.seed do |s|
  s.id = 7
  s.user_id = 10
  s.position_id = 3
end

UserPosition.seed do |s|
  s.id = 8
  s.user_id = 11
  s.position_id = 3
end

UserPosition.seed do |s|
  s.id = 9
  s.user_id = 12
  s.position_id = 3
end

#user_id=13-46:その他の技師 position_id=4:診療放射線技師 position_id=5:卒業生
UserPosition.seed(:id,
{ id: 10, user_id: 13, position_id: 4 },
{ id: 11, user_id: 14, position_id: 4 },
{ id: 12, user_id: 15, position_id: 4 },
{ id: 13, user_id: 16, position_id: 4 },
{ id: 14, user_id: 17, position_id: 4 },
{ id: 15, user_id: 18, position_id: 4 },
{ id: 16, user_id: 19, position_id: 4 },
{ id: 17, user_id: 20, position_id: 4 },
{ id: 18, user_id: 21, position_id: 4 },
{ id: 19, user_id: 22, position_id: 4 },
{ id: 20, user_id: 23, position_id: 4 },
{ id: 22, user_id: 25, position_id: 4 },
{ id: 23, user_id: 26, position_id: 4 },
{ id: 24, user_id: 27, position_id: 4 },
{ id: 25, user_id: 28, position_id: 4 },
{ id: 26, user_id: 29, position_id: 4 },
{ id: 27, user_id: 30, position_id: 4 },
{ id: 28, user_id: 31, position_id: 4 },
{ id: 30, user_id: 33, position_id: 4 },
{ id: 32, user_id: 35, position_id: 4 },
{ id: 33, user_id: 36, position_id: 4 },
{ id: 34, user_id: 37, position_id: 4 },
{ id: 35, user_id: 38, position_id: 4 },
{ id: 37, user_id: 40, position_id: 4 },
{ id: 38, user_id: 41, position_id: 4 },
{ id: 39, user_id: 42, position_id: 4 },
{ id: 42, user_id: 45, position_id: 4 },
)

UserPosition.seed(:id,
{ id: 44, user_id: 32, position_id: 5 },
{ id: 45, user_id: 34, position_id: 5 },
{ id: 46, user_id: 43, position_id: 5 },
{ id: 47, user_id: 46, position_id: 5 },
)
