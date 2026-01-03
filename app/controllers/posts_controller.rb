class PostsController < ApplicationController
  before_action :ensure_correct_user, {only: [:update, :destroy]}
  before_action :ensure_graduate, {only: [:new, :edit, :create, :update, :destroy]}
  before_action :ensure_correct_work_user, {only: [:show]}

  def top
    #未読があるか、ある場合はどの掲示板の未読か判別
    unreads = @current_user.unreads.where(anonymous_post_id: nil).where.not(post_id: nil)
    if unreads.present?
      unreads.each do |unread|
        if unread.department_id.blank? && unread.work_id.blank?
          @unread_post = true
        elsif unread.department_id.present? && unread.work_id.blank?
          @unread_department = true
        elsif unread.department_id.blank? && unread.work_id.present?
          @unread_work = true
        end
      end
    end
  end

  def index
    @posts = Post.where(meeting: true).order(created_at: "DESC").page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: "DESC")
    #未読解除処理
    unreads = Unread.where(user_id: @current_user.id, post_id: @post.id)
    unreads.each do |unread|
      unread.destroy
    end
  end

  def new
    @post = Post.new
    @post.images.build
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = @current_user.id

    if @post.save
      params[:post][:images]&.each do |image|
        img = @post.images.build(image: image)
        img.save
      end
      #新規投稿の通知処理
      #@post.save_notification_post!(@current_user)
      #未読ステータス登録処理
      users = User.where.not(id: @post.user_id)
      users.each do |user|
        unread = Unread.create(user_id: user.id, post_id: @post.id)
      end
      redirect_to post_url(@post), notice: "新規投稿しました。"
    else
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
      params[:post][:images]&.each { |image| @post.images.create(image: image) }
      redirect_to @post, notice: "更新が成功しました"
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
    #卒業生か確認
    def ensure_graduate
      if @current_user.position_ids.include?(5)
        redirect_to posts_url, notice: "権限がありません"
      end
    end
    #ストロングパラメータ
    def post_params
      params.require(:post).permit(:title, :content, :meeting)
    end
    #該当係りに所属しているか確認
    def ensure_correct_work_user
      post = Post.find(params[:id])
      if post.work_id.present? == true && post.meeting == false && @current_user.works.ids.include?(post.work_id) == false
        redirect_to posts_url, notice: "非公開の投稿です"
      end
    end


end
