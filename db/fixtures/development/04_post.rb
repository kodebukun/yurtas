5.times do |n|
  Post.seed do |s|
    s.title = "テストタイトル1-#{n}"
    s.content = "テスト投稿1-#{n}"
    s.user_id = 1
    s.work_id = 3
    s.department_id = 5
  end
end

4.times do |n|
  Post.seed do |s|
    s.title = "meetingタイトル2-#{n}"
    s.content = "meeting投稿2-#{n}"
    s.user_id = 2
    s.work_id = 4
    s.department_id = 6
    s.meeting = true
  end
end

3.times do |n|
  Post.seed do |s|
    s.title = "テストタイトル3-#{n}"
    s.content = "テスト投稿2-#{n}"
    s.user_id = 3
    s.work_id = 5
    s.department_id = 1
  end
end
