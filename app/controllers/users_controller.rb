class UsersController < ApplicationController
  before_action :ensure_correct_user, {only: [:edit, :update]}
  before_action :require_admin, {only: [:new, :create]}

  def index
    @users = User.all.order(login_id: :asc)
  end

  def show
    @user = User.find(params[:id])
    @works = @user.works.all
    @positions = @user.positions.all
    @departments = @user.departments.all
  end

  def new
    @user = User.new
    @departments = Department.all
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
    @departments = Department.all
    @works = Work.all
  end

  def update
    @user = User.find(params[:id])
    @departments = Department.all
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
      params.require(:user).permit(:name, :login_id, :phone_no, :email, :password, :password_confirmation, department_ids: [], work_ids: [], position_ids: [])
    end

    def params_unless_password
      params.require(:user).permit(:name, :login_id, :phone_no, :email, department_ids: [], work_ids: [])
    end

end
