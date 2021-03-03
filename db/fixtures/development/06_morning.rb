3.times do |n|
  Morning.seed do |s|
    s.title = "朝テストタイトル#{n}"
    s.content = "朝テスト投稿#{n}"
    s.user_id = n
    s.absentee = "朝テスト欠席者#{n}"
  end
end

3.times do |n|
  Morning.seed do |s|
    s.title = "朝テストタイトル1-#{n}"
    s.content = "朝テスト投稿1-#{n}"
    s.user_id = 1
    s.absentee = "朝テスト欠席者1-#{n}"
  end
end
