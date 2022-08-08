class AnonymousPost < ApplicationRecord
  validates :title, {presence: true, length: {maximum: 140}}
  validates :content, {presence: true}
  validates :user_id, {presence: true}

  has_many :anonymous_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :evaluations, dependent: :destroy
  has_one :breach, dependent: :destroy

  belongs_to :user

  def create_notification_comment!(current_user, anonymous_comment_id)
    # 自分と投稿者以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = AnonymousComment.select(:user_id).where(anonymous_post_id: self.id).where.not(user_id: [current_user.id, self.user_id]).distinct
    temp_ids.each do |temp_id|
      self.save_notification_comment!(current_user, anonymous_comment_id, temp_id["user_id"])
    end
    # 投稿者にも通知を送る
    self.save_notification_comment!(current_user, anonymous_comment_id, self.user_id)
  end

  def save_notification_comment!(current_user, anonymous_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      anonymous_post_id: self.id,
      anonymous_comment_id: anonymous_comment_id,
      visited_id: visited_id,
      action: "anonymous_comment"
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end
