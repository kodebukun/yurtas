class DepartmentPostsController < ApplicationController
  before_action :ensure_correct_user, {only: [:update, :destroy]}
  before_action :ensure_graduate, {only: [:new, :edit, :create, :update, :destroy]}

  def top
    @departments = Department.all
  end

  def index
    @department = Department.find(params[:department_id])
    @posts = Post.where(department_id: @department.id, rule: false).order(created_at: "DESC").page(params[:page]).per(10)
    #自分が所属する部署の場合は全て表示、所属しない部署の場合はmeeting:trueのみ表示の処理
    #if @current_user.departments.ids.include?(@department.id)
    #  @posts = Post.where(department_id: @department.id, rule: false).order(created_at: "DESC").page(params[:page]).per(10)
    #else
    #  @posts = Post.where(department_id: @department.id, rule: false).where(meeting: true).order(created_at: "DESC").page(params[:page]).per(10)
    #end
    @role_posts = Post.where(department_id: @department.id, rule: true).order(created_at: "DESC").page(params[:page]).per(10)
  end

  def new
    @post = Post.new
    @department = Department.find(params[:department_id])
  end

  def edit
    @post = Post.find(params[:id])
    @department = @post.department
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = @current_user.id
    if @post.save
      #通知処理
      #if @post.meeting
        #@post.save_notification_post!(@current_user)
      #else
        #@post.save_notification_department!(@current_user)
      #end
      #未読ステータス登録処理（meeting：falseの場合は該当部署にだけ未読処理）
      if @post.meeting == true
        users = User.where.not(id: @post.user_id)
      else
        users = @post.department.users.where.not(id: @post.user_id)
      end
      users.each do |user|
        unread = Unread.create(user_id: user.id, post_id: @post.id, department_id: @post.department_id)
      end
      redirect_to post_url(@post), notice: "新規投稿しました。"
    else
      @department = @post.department
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      #meetingオンの場合、全体に通知処理
      if @post.meeting
        @post.save_notification_post!(@current_user)
      end
      redirect_to post_url, notice: "投稿を編集しました。"
    else
      @department = @post.department
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to department_posts_url(department_id: post.department_id), notice: "投稿を削除しました。"
  end

  private

    #投稿者本人か確認
    def ensure_correct_user
      @post = Post.find(params[:id])
      if @post.user_id != @current_user.id
        redirect_to department_posts_url, notice: "権限がありません"
      end
    end
    #卒業生か確認
    def ensure_graduate
      if @current_user.position_ids.include?(5)
        redirect_to index_url, notice: "権限がありません"
      end
    end
    #ストロングパラメータ
    def post_params
      params.require(:post).permit(:title, :content, :rule, :meeting, :department_id)
    end

end
