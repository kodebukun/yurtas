class WorkPostsController < ApplicationController
  before_action :ensure_correct_user, {only: [:update, :destroy]}
  before_action :ensure_graduate, {only: [:new, :edit, :create, :update, :destroy]}

  def top
    @works = Work.all
  end

  def index
    @work = Work.find(params[:work_id])
    #自分が所属する係りの場合は全て表示、所属しない係りの場合はmeeting:trueのみ表示の処理
    if @current_user.works.ids.include?(@work.id)
      @posts = Post.where(work_id: @work.id).order(created_at: "DESC").page(params[:page]).per(10)
    else
      @posts = Post.where(work_id: @work.id).where(meeting: true).order(created_at: "DESC").page(params[:page]).per(10)
    end
  end

  def new
    @post = Post.new
    @post.images.build
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
      failed_images = []
      params[:post][:images]&.each do |image|
        img = @post.images.build(image: image)
        failed_images << img.errors.full_messages.join("、") unless img.save
      end
      #通知処理（初回投稿時のみ）
      if @post.meeting
        @post.save_notification_post!(@current_user)
      else
        @post.save_notification_work!(@current_user)
      end
      #未読ステータス登録処理（meeting：falseの場合は該当係りにだけ未読処理）
      if @post.meeting == true
        users = User.where.not(id: @post.user_id)
      else
        users = @post.work.users.where.not(id: @post.user_id)
      end
      users.each do |user|
        unread = Unread.create(user_id: user.id, post_id: @post.id, work_id: @post.work_id)
      end
      notice = "新規投稿しました。"
      notice += " ただし一部の画像/PDFの保存に失敗しました（#{failed_images.join("、")}）" if failed_images.any?
      redirect_to post_url(@post), notice: notice
    else
      @work = @post.work
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])

    if params[:post][:delete_images].present?
      params[:post][:delete_images].each do |image_id|
        # 削除処理
        image = @post.images.find_by(id: image_id)
        # 画像が見つかった場合のみ削除
        if image
          image.destroy
        else
          Rails.logger.warn("Image not found with ID: #{image_id}")
        end
      end
    end

    if @post.update(post_params)
      failed_images = []
      params[:post][:images]&.each do |image|
        img = @post.images.create(image: image)
        failed_images << img.errors.full_messages.join("、") unless img.persisted?
      end
      notice = "投稿を編集しました。"
      notice += " ただし一部の画像/PDFの保存に失敗しました（#{failed_images.join("、")}）" if failed_images.any?
      redirect_to post_url, notice: notice
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
    #ストロングパラメータ
    def post_params
      params.require(:post).permit(:title, :content, :meeting, :work_id)
    end

end
