class PostsController < ApplicationController
  before_action :ensure_correct_user, {only: [:update, :destroy]}

  def top
  end

  def index
    @posts = Post.where(meeting: true).order(created_at: "DESC").page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: "DESC")
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = @current_user.id
    if @post.save
      #新規投稿の通知処理
      @post.save_notification_post!(@current_user)
      redirect_to post_url(@post), notice: "新規投稿しました。"
    else
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_url, notice: "投稿を編集しました。"
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_url, notice: "投稿を削除しました。"
  end

  private

    #投稿者本人か確認
    def ensure_correct_user
      @post = Post.find(params[:id])
      if @post.user_id != @current_user.id
        redirect_to posts_url, notice: "権限がありません"
      end
    end
    #ストロングパラメータ
    def post_params
      params.require(:post).permit(:title, :content, :meeting)
    end

end
