class UsersController < ApplicationController
  before_action :ensure_correct_user, {only: [:edit, :update]}
  before_action :require_admin, {only: [:new, :create, :destroy]}

  def index
    @users = User.all.where.not(id: 1 .. 3)
    @active_users = @users.joins(:user_positions).where.not("user_positions.position_id = ?", 5).order(id: "ASC")
  end

  def show
    @user = User.find(params[:id])
    @works = @user.works.all
    @positions = @user.positions.all
    @departments = @user.departments.all.order(order: "ASC")
  end

  def new
    @user = User.new
    @departments = Department.all.order(order: "ASC")
    @works = Work.all
    @positions = Position.all
  end

  def create
    @user = User.new(user_params)
    @user.image_name = "default_user.jpg"
    if @user.save
      redirect_to user_url(@user), notice: "ユーザー登録が完了しました"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @departments = Department.all.order(order: "ASC")
    @works = Work.all
  end

  def update
    @user = User.find(params[:id])
    @departments = Department.all.order(order: "ASC")
    @works = Work.all
    if user_params[:password].present? || user_params[:password_confirmation].present?
      if @user.update(user_params)
        redirect_to user_url(@user), notice: "ユーザー情報とパスワードを更新しました"
      else
        render :edit
      end
    else
      if @user.update(params_unless_password)
        redirect_to user_url(@user), notice: "ユーザー情報を更新しました"
      else
        render :edit
      end
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_url, notice: "ユーザーを削除しました。"
  end


  private
    #本人か確認
    def ensure_correct_user
      if @current_user.id != params[:id].to_i
        redirect_to index_url, notice: "権限がありません"
      end
    end
    #管理者か確認
    def require_admin
        redirect_to signup_text_url, notice: "権限がありません" unless current_user.admin?
    end
    #ストロングパラメーター
    def user_params
      params.require(:user).permit(:name, :login_id, :phone_no, :email, :comment, :password, :password_confirmation, :night_shift, :day_shift, :call, department_ids: [], work_ids: [], position_ids: [])
    end

    def params_unless_password
      params.require(:user).permit(:name, :login_id, :phone_no, :email, :comment, :night_shift, :day_shift, :call, department_ids: [], work_ids: [])
    end

end
