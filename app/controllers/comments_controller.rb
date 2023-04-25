class CommentsController < ApplicationController
  before_action :ensure_correct_user, {only: [:update, :destroy]}
  before_action :ensure_graduate

  def new
    @comment = Comment.new
    if params[:post_id]
      @post = Post.find(params[:post_id])
    elsif params[:morning_id]
      @morning = Morning.find(params[:morning_id])
    elsif params[:diary_id]
      @diary = Diary.find(params[:diary_id])
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = @current_user.id

    if @comment.post
      @post = @comment.post
      if @comment.save
        #係りか部署の投稿に対するコメントは、該当係り/部署の人にだけ未読処理
        if @post.department_id.present? && @post.work_id == nil
          users = @post.department.users.where.not(id: @comment.user_id)
          users.each do |user|
            same_unread = Unread.find_by(user_id: user.id, post_id: @post.id, department_id: @post.department_id)
            if same_unread.blank?
              unread = Unread.create(user_id: user.id, post_id: @post.id, department_id: @post.department_id)
            end
          end
          redirect_to post_url(@post), notice: "コメントを投稿しました。"
        elsif @post.department_id == nil && @post.work_id.present?
          users = @post.work.users.where.not(id: @comment.user_id)
          users.each do |user|
            same_unread = Unread.find_by(user_id: user.id, post_id: @post.id, work_id: @post.work_id)
            if same_unread.blank?
              unread = Unread.create(user_id: user.id, post_id: @post.id, work_id: @post.work_id)
            end
          end
          redirect_to post_url(@post), notice: "コメントを投稿しました。"
        else
          #その他はコメントの通知処理
          @post.create_notification_comment!(@current_user, @comment.id)
          redirect_to post_url(@post), notice: "コメントを投稿しました。"
        end
      else
        render :new
      end
    elsif @comment.morning
      @morning = @comment.morning
      if @comment.save
        #コメントの通知処理
        @morning.create_notification_comment!(@current_user, @comment.id)
        redirect_to morning_url(@morning), notice: "コメントを投稿しました。"
      else
        render :new
      end
    elsif @comment.diary
      @diary = @comment.diary
      if @comment.save
        #コメントの通知処理
        @diary.create_notification_comment!(@current_user, @comment.id)
        redirect_to diary_url(@diary), notice: "コメントを投稿しました。"
      else
        render :new
      end
    end

  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      if @comment.post
        redirect_to post_url(@comment.post), notice: "コメントを編集しました。"
      elsif @comment.morning
        redirect_to morning_url(@comment.morning), notice: "コメントを編集しました。"
      elsif @comment.diary
        redirect_to diary_url(@comment.diary), notice: "コメントを編集しました。"
      end
    else
      render :edit
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    if comment.post
      redirect_to post_url(comment.post), notice: "コメントを削除しました。"
    elsif comment.morning
      redirect_to morning_url(comment.morning), notice: "コメントを削除しました。"
    elsif comment.diary
      redirect_to diary_url(comment.diary), notice: "コメントを削除しました。"
    end
  end

  private
    #投稿者本人か確認
    def ensure_correct_user
      @comment = Comment.find(params[:id])
      if @comment.user_id != @current_user.id
        redirect_to index_url, notice: "権限がありません"
      end
    end
    #卒業生か確認
    def ensure_graduate
      if @current_user.position_ids.include?(5)
        redirect_to index_url, notice: "権限がありません"
      end
    end
    #ストロングパラメータ
    def comment_params
      params.require(:comment).permit(:content, :post_id, :morning_id, :diary_id)
    end

end
