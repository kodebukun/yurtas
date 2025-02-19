class Post < ApplicationRecord
  validates :title, {presence: true, length: {maximum: 140}}
  validates :content, {presence: true}
  validates :user_id, {presence: true}

  has_many :notifications, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :unreads, dependent: :destroy
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  belongs_to :user
  belongs_to :work, optional: true
  belongs_to :department, optional: true


  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, self.user_id, self.id, "like"])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: self.id,
        visited_id: self.user_id,
        action: "like"
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, comment_id)
    # 自分と投稿者以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(post_id: self.id).where.not(user_id: [current_user.id, self.user_id]).distinct
    temp_ids.each do |temp_id|
      self.save_notification_comment!(current_user, comment_id, temp_id["user_id"])
    end
    # 投稿者にも通知を送る
    self.save_notification_comment!(current_user, comment_id, self.user_id)
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: self.id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: "comment"
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  def save_notification_post!(current_user)
    # 自分以外の全員に通知を送る
    visited_users = User.all.where.not(id: current_user.id)
    visited_users.each do |visited_user|
      notification = current_user.active_notifications.new(
        post_id: self.id,
        visited_id: visited_user.id,
        action: "post"
      )
      notification.save if notification.valid?
    end
  end

  def save_notification_department!(current_user)
    # 自分以外の全員に通知を送る
    department = Department.find(self.department_id)
    visited_users = department.users.where.not(id: current_user.id)
    visited_users.each do |visited_user|
      notification = current_user.active_notifications.new(
        post_id: self.id,
        visited_id: visited_user.id,
        action: "department"
      )
      notification.save if notification.valid?
    end
  end

  def save_notification_work!(current_user)
    # 自分以外の全員に通知を送る
    work = Work.find(self.work_id)
    visited_users = work.users.where.not(id: current_user.id)
    visited_users.each do |visited_user|
      notification = current_user.active_notifications.new(
        post_id: self.id,
        visited_id: visited_user.id,
        action: "work"
      )
      notification.save if notification.valid?
    end
  end
end
