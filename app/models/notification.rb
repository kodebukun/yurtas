class Notification < ApplicationRecord
  PUSH_EXCLUDED_ACTIONS = %w[like].freeze

  default_scope -> { order(created_at: :desc) }
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
  belongs_to :morning, optional: true
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
  belongs_to :diary, optional: true
  belongs_to :anonymous_post, optional: true
  belongs_to :anonymous_comment, optional: true

  after_create :send_push_notification

  private

  def send_push_notification
    return if PUSH_EXCLUDED_ACTIONS.include?(action)
    return if visited.nil?
    return if visitor_id == visited_id

    subscriptions = visited.push_subscriptions
    return if subscriptions.empty?

    payload = { title: push_title, body: push_body, url: push_url }.to_json
    vapid = {
      public_key:  Rails.application.config.x.vapid_public_key,
      private_key: Rails.application.config.x.vapid_private_key,
      subject:     Rails.application.config.x.vapid_subject
    }

    subscriptions.each do |sub|
      Webpush.payload_send(
        message: payload,
        endpoint: sub.endpoint,
        p256dh: sub.p256dh,
        auth: sub.auth,
        vapid: vapid
      )
    rescue Webpush::ExpiredSubscription, Webpush::InvalidSubscription
      sub.destroy
    rescue StandardError
      # push失敗は握り潰す(元のリクエストを失敗させない)
    end
  end

  def push_title
    name = visitor&.name ? "#{visitor.name}さん" : '誰か'
    case action
    when 'comment'    then "#{name}がコメントしました"
    when 'post'       then "#{name}が投稿しました"
    when 'department' then "#{name}が部署に投稿しました"
    when 'work'       then "#{name}が業務に投稿しました"
    else              "新しい通知があります"
    end
  end

  def push_body
    case action
    when 'comment'
      comment&.content&.truncate(60) || anonymous_comment&.content&.truncate(60) || ''
    when 'post', 'department', 'work'
      post&.title&.truncate(60) || ''
    else
      ''
    end
  end

  def push_url
    '/notifications'
  end
end
