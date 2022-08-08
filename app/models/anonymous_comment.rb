class AnonymousComment < ApplicationRecord
  validates :content, {presence: true}
  validates :user_id, {presence: true}
  validates :nickname, {presence: true}

  has_many :notifications, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one :breach, dependent: :destroy

  belongs_to :user
  belongs_to :anonymous_post, optional: true

  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and comment_id = ? and action = ? ", current_user.id, self.user_id, self.id, "like"])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        anonymous_comment_id: self.id,
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


end
