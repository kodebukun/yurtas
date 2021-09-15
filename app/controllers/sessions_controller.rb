class SessionsController < ApplicationController
  skip_before_action :login_required

  def create
    user = User.find_by(login_id: session_params[:login_id])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to index_url, notice: "ログインしました"
    else
      @error_message = "IDまたはパスワードが間違っています"
      @login_id = session_params[:login_id]
      @password = session_params[:password]
      render("home/top")
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "ログアウトしました"
  end

  private

  def session_params
    params.require(:session).permit(:login_id, :password)
  end

end
