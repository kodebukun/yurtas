class Post < ApplicationRecord
  validates :title, {presence: true, length: {maximum: 140}}
  validates :content, {presence: true}
  validates :user_id, {presence: true}

  #has_many :notifications, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  belongs_to :user
  belongs_to :work, optional: true
  belongs_to :department, optional: true

  #def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
  #  temp = Notification.where(["visitor_id = ? and visited_id = ? and request_id = ? and action = ? ", current_user.id, self.user_id, self.id, "like"])
    # いいねされていない場合のみ、通知レコードを作成
  #  if temp.blank?
  #    notification = current_user.active_notifications.new(
  #      request_id: self.id,
  #      visited_id: self.user_id,
  #      action: "like"
  #    )
  #    # 自分の投稿に対するいいねの場合は、通知済みとする
  #    if notification.visitor_id == notification.visited_id
  #      notification.checked = true
  #    end
  #    notification.save if notification.valid?
  #  end
  #end

  #def create_notification_reply!(current_user, reply_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
  #  temp_ids = Reply.select(:user_id).where(request_id: self.id).where.not(user_id: current_user.id).distinct
  #  temp_ids.each do |temp_id|
  #    self.save_notification_reply!(current_user, reply_id, temp_id["user_id"])
  #  end
    # 投稿者にも通知を送る
  #  self.save_notification_reply!(current_user, reply_id, self.user_id)
  #end

  #def save_notification_reply!(current_user, reply_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
  #  notification = current_user.active_notifications.new(
  #    request_id: self.id,
  #    reply_id: reply_id,
  #    visited_id: visited_id,
  #    action: "reply"
  #  )
    # 自分の投稿に対するコメントの場合は、通知済みとする
  #  if notification.visitor_id == notification.visited_id
  #    notification.checked = true
  #  end
  #  notification.save if notification.valid?
  #end

  #def save_notification_post!(current_user)
    # 自分以外の、自分の投稿と同じworkに所属してる人をすべて取得し、全員に通知を送る
  #  post_work = Work.find_by(id: self.work_id)
  #  visited_users = post_work.users
  #  visited_users.each do |visited_user|
  #    notification = current_user.active_notifications.new(
  #      request_id: self.id,
  #      visited_id: visited_user.id,
  #      action: "post"
  #    )
      # 自分の投稿に対するいいねの場合は、通知済みとする
  #    if notification.visitor_id == notification.visited_id
  #      notification.checked = true
  #    end
  #    notification.save if notification.valid?
  #  end
  #end

  #def return_select
  #  if self.work_id >=1 && self.work_id <= 17
  #    return "works"
  #  elsif self.work_id >= 18 && self.work_id <= 24
  #    return "departments"
  #  end
  #end


end
