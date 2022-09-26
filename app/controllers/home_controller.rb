class HomeController < ApplicationController
  skip_before_action :login_required, {only: [:top, :about, :signup_text, :login_help]}
  before_action :already_logged_in, {only: :top}

  def top
  end

  def about
  end

  def index_second
    @posts = Post.where(meeting: true).order(created_at: "DESC").limit(7)
    @mornings = Morning.all.order(created_at: "DESC").limit(7)
  end

  def index
    @posts = Post.where(meeting: true).order(created_at: "DESC").limit(5)
    @mornings = Morning.all.order(created_at: "DESC").limit(5)
    temp = @posts | @mornings
    @news = temp.sort!{ |a, b| b.created_at <=> a.created_at }.take(6)
    @anonymous_unread = Unread.where.not(anonymous_post_id: nil).find_by(user_id: @current_user.id)
    @posts_unread = Unread.where.not(post_id: nil).find_by(user_id: @current_user.id)
    @breaches_unread = Breach.where(checked: false)
  end

  def signup_text
  end

  def login_help
  end

  def help

  end

  private

    def already_logged_in
      redirect_to index_url, notice: "すでにログインしています" if session[:user_id]
    end

end
