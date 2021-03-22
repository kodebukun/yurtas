class NotificationsController < ApplicationController

  def index
    @notifications = @current_user.passive_notifications.page(params[:page]).per(10)
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  def destroy
    my_notifications = @current_user.passive_notifications
    my_notifications.each do |my_notification|
      my_notification.destroy
    end
    redirect_to notifications_url, notice: "通知を削除しました"
  end

end
