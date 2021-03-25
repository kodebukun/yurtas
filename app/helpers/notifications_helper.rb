module NotificationsHelper
  def notification_form(notification)
    visitor = link_to notification.visitor.name, user_path(notification.visitor)
    visited = notification.visited

    case notification.action
      when "like" then
        if notification.post
          your_post = link_to "あなたの投稿", post_path(notification.post)
          visitor + " さんが " + your_post + " にいいね！しました。"
        else
          your_comment = link_to "あなたのコメント", post_path(notification.comment.post)
          visitor + " さんが " + your_comment + " にいいね！しました。"
        end
      when "comment" then
        your_post = link_to "あなたの投稿", post_path(notification.post)
        someone_post = link_to "#{notification.post.user.name}さんの投稿", post_path(notification.post)
        if notification.post.user_id == visited.id
          visitor + " さんが " + your_post + " にコメントしました。"
        else
          visitor + " さんが " + someone_post + " にコメントしました。"
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
    end
  end
end
