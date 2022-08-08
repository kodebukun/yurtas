module NotificationsHelper
  def notification_form(notification)
    visitor = link_to notification.visitor.name, user_path(notification.visitor)
    visited = notification.visited

    case notification.action
      when "like" then
        if notification.post
          your_post = link_to "あなたの投稿", post_path(notification.post)
          visitor + " さんが " + your_post + " にいいね！しました。"
        elsif notification.comment
          if notification.comment.post
            your_comment = link_to "あなたのコメント", post_path(notification.comment.post)
            visitor + " さんが " + your_comment + " にいいね！しました。"
          elsif notification.comment.morning
            your_morning_comment = link_to "あなたのコメント", morning_path(notification.comment.morning)
            visitor + " さんが " + your_morning_comment + " にいいね！しました。"
          elsif notification.comment.diary
            your_diary_comment = link_to "あなたのコメント", diary_path(notification.comment.diary)
            visitor + " さんが " + your_diary_comment + " にいいね！しました。"
          end
        elsif notification.morning
          your_morning = link_to "あなたの投稿", morning_path(notification.morning)
          visitor + " さんが " + your_morning + " にいいね！しました。"
        elsif notification.diary
          your_diary = link_to "あなたの投稿", diary_path(notification.diary)
          visitor + " さんが " + your_diary + " にいいね！しました。"
        elsif notification.anonymous_comment
          your_anonymous_comment = link_to "あなたの匿名コメント", anonymous_post_path(notification.anonymous_comment.anonymous_post)
          your_anonymous_comment + " にいいね！されました。"
        end
      when "comment" then
        if notification.post
          your_post = link_to "あなたの投稿", post_path(notification.post)
          someone_post = link_to "#{notification.post.user.name}さんの投稿", post_path(notification.post)
          if notification.post.user_id == visited.id
            visitor + " さんが " + your_post + " にコメントしました。"
          else
            visitor + " さんが " + someone_post + " にコメントしました。"
          end
        elsif notification.morning
          your_post = link_to "あなたの投稿", morning_path(notification.morning)
          someone_post = link_to "#{notification.morning.user.name}さんの投稿", morning_path(notification.morning)
          if notification.morning.user_id == visited.id
            visitor + " さんが " + your_post + " にコメントしました。"
          else
            visitor + " さんが " + someone_post + " にコメントしました。"
          end
        elsif notification.diary
          your_post = link_to "あなたの投稿", diary_path(notification.diary)
          someone_post = link_to "#{notification.diary.user.name}さんの投稿", diary_path(notification.diary)
          if notification.diary.user_id == visited.id
            visitor + " さんが " + your_post + " にコメントしました。"
          else
            visitor + " さんが " + someone_post + " にコメントしました。"
          end
        end
      when "post" then
        new_post = link_to "新規投稿", post_path(notification.post)
        visitor + " さんが全体の投稿に " + new_post + " しました。"
      when "department" then
        new_post = link_to "新規投稿", post_path(notification.post)
        department = notification.post.department
        visitor + " さんが#{department.name}の投稿に " + new_post + " しました。"
      when "work" then
        new_post = link_to "新規投稿", post_path(notification.post)
        work = notification.post.work
        visitor + " さんが#{work.name}の投稿に " + new_post + " しました。"
      when "diary" then
        new_diary = link_to "新規投稿", diary_path(notification.diary)
        visitor + " さんが宿直日誌に " + new_diary + " しました。"
      when "anonymous_comment" then
        your_anonymous_post = link_to "あなたの匿名投稿", anonymous_post_path(notification.anonymous_post)
        someone_anonymous_post = link_to "あなたがコメントした匿名投稿", anonymous_post_path(notification.anonymous_post)
        if notification.anonymous_post.user_id == visited.id
          your_anonymous_post + " にコメントされました。"
        else
          someone_anonymous_post + " にコメントされました。"
        end
    end
  end
end
