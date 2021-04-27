class CommentsController < ApplicationController
  before_action :ensure_correct_user, {only: [:update, :destroy]}

  def new
    @comment = Comment.new
    @post = Post.find(params[:post_id])
  end

  def new_morning
    @comment = Comment.new
    @morning = Morning.find(params[:morning_id])
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def edit_morning
    @comment = Comment.find(params[:id])
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = @current_user.id

    if @comment.post
      @post = @comment.post
      if @comment.save
        #コメントの通知処理
        @post.create_notification_comment!(@current_user, @comment.id)
        redirect_to post_url(@post), notice: "コメントを投稿しました。"
      else
        render :new
      end
    elsif @comment.morning
      @morning = @comment.morning
      if @comment.save
        #コメントの通知処理は無し
        redirect_to morning_url(@morning), notice: "コメントを投稿しました。"
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
    #ストロングパラメータ
    def comment_params
      params.require(:comment).permit(:content, :post_id, :morning_id)
    end

end
