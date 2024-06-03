class AnonymousPost < ApplicationRecord
  validates :title, {presence: true, length: {maximum: 50}}
  validates :content, {presence: true, length: {maximum: 300}}
  validates :user_id, {presence: true}

  has_many :anonymous_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :evaluations, dependent: :destroy
  has_one :breach, dependent: :destroy
  has_many :unreads, dependent: :destroy

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

  #2か月以前の投稿と解決済みの投稿を取得（クラスメソッドとして定義）
  def self.past_posts
    now = Time.current
    start_month = 6.months.ago.all_month.first
    past_posts = self.where.not(updated_at: start_month..now, resolved: false)
    return past_posts
  end

  #2か月以内の投稿かつ未解決の投稿を取得（クラスメソッドとして定義）
  def self.recent_posts
    now = Time.current
    start_month = 6.months.ago.all_month.first
    @recent_posts = self.where(updated_at: start_month..now, resolved: false)
    return @recent_posts
  end

end
