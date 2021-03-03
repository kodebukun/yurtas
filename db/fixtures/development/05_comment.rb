2.times do |n|
  Comment.seed do |s|
    s.content = "テストコメント1-#{n}"
    s.user_id = 1
    s.post_id = 1
  end
end

2.times do |n|
  Comment.seed do |s|
    s.content = "テストコメント2-#{n}"
    s.user_id = 2
    s.post_id = 2
  end
end

2.times do |n|
  Comment.seed do |s|
    s.content = "テストコメント3-#{n}"
    s.user_id = 3
    s.post_id = 3
  end
end
