class UsersController < ApplicationController
  before_action :ensure_correct_user, {only: [:edit, :update]}
  before_action :require_admin, {only: [:new, :create]}

  def index
    @users = User.all.order(login_id: :asc)
  end

  def show
    @user = User.find(params[:id])
    #@works = @user.works
    #@positions = @user.positions
  end

  def new
    @user = User.new
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
    #@works = Work.all
    #@my_works = @user.works
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to user_url(@user), notice: "ユーザー情報を更新しました"
    else
      render :edit
    end

  #  if @user.user_works.exists?
  #    @my_works = @user.user_works
  #    @my_works.each do |my_work|
  #      my_work.destroy
  #    end
  #  end
  #  @works = Work.all
  #  @works.each do |work|
  #    if params[:"work#{work.id}"]
  #      @user.user_works.create(work_id: params[:"work#{work.id}"])
  #    end
  #  end
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
      params.require(:user).permit(:name, :login_id, :password, :phone_no, :email)
    end

end
