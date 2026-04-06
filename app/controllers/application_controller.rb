class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to root_url, notice: "ログインが必要です" unless current_user
  end

  def require_admin
    redirect_to root_url, notice: "権限がありません" unless current_user.admin?
  end

  def ensure_graduate
    if @current_user.position_ids.include?(5)
      redirect_to root_url, notice: "権限がありません"
    end
  end

end
