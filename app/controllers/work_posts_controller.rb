class WorkPostsController < ApplicationController
  before_action :ensure_correct_user, {only: [:update, :destroy]}
  before_action :ensure_graduate, {only: [:new, :edit, :create, :update, :destroy]}

  def top
    @works = Work.all
  end

  def index
    @work = Work.find(params[:work_id])
    @posts = Post.where(work_id: @work.id).order(created_at: "DESC").page(params[:page]).per(10)
  end

  def new
    @post = Post.new
    @work = Work.find(params[:work_id])
  end

  def edit
    @post = Post.find(params[:id])
    @work = @post.work
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = @current_user.id
    if @post.save
      #通知処理
      #if @post.meeting
        #@post.save_notification_post!(@current_user)
      #else
        #@post.save_notification_work!(@current_user)
      #end
      #未読ステータス登録処理
      users = User.where.not(id: @post.user_id)
      users.each do |user|
        unread = Unread.create(user_id: user.id, post_id: @post.id, work_id: @post.work_id)
      end
      redirect_to post_url(@post), notice: "新規投稿しました。"
    else
      @work = @post.work
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
      @work = @post.work
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to work_posts_url(work_id: post.work_id), notice: "投稿を削除しました。"
  end

  private

    #投稿者本人か確認
    def ensure_correct_user
      @post = Post.find(params[:id])
      if @post.user_id != @current_user.id
        redirect_to work_posts_url, notice: "権限がありません"
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
      params.require(:post).permit(:title, :content, :meeting, :work_id)
    end

end
