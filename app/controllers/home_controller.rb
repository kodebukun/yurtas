class HomeController < ApplicationController
  skip_before_action :login_required, {only: [:top, :about, :signup_text]}
  before_action :already_logged_in, {only: :top}

  def top
  end

  def about
  end

  def index
  end

  def signup_text
  end

  private

    def already_logged_in
      redirect_to index_url, notice: "すでにログインしています" if session[:user_id]
    end

end
