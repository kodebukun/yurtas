class DepartmentPostsController < ApplicationController
  before_action :ensure_correct_user, {only: [:update, :destroy]}

  def top
    @departments = Department.all
  end

  def index
    @department = Department.find(params[:department_id])
    @posts = Post.where(department_id: @department.id).order(created_at: "DESC").page(params[:page]).per(10)
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
      redirect_to post_url(@post), notice: "新規投稿しました。"
    else
      @department = @post.department
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
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
    #ストロングパラメータ
    def post_params
      params.require(:post).permit(:title, :content, :meeting, :department_id)
    end

end
