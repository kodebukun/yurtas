class AnonymousCommentsController < ApplicationController
  before_action :require_admin, {only: [:update, :destroy]}
  before_action :ensure_graduate

  def new
    @comment = AnonymousComment.new
    @post = AnonymousPost.find(params[:post_id])
    if @post.user_id == @current_user.id
      @nickname = "投稿者"
    else
      @previous_comment = AnonymousComment.where(anonymous_post_id: @post.id).find_by(user_id: @current_user.id)
      if @previous_comment
        @nickname = @previous_comment.nickname
      else
        previous_nicknames = AnonymousComment.where(anonymous_post_id: @post.id).where.not(nickname: "投稿者").select(:nickname).distinct
        nickname_count = previous_nicknames.count + 1
        @nickname = "名無し" + "#{nickname_count}"
      end
    end
  end

  def create
    @comment = AnonymousComment.new(comment_params)
    @comment.user_id = @current_user.id
    str = @comment.nickname
    #ニックネームの空白削除
    @comment.nickname = str.gsub(/　/," ").gsub(" ", "")
    @post = @comment.anonymous_post
    if @comment.save
      #postのupdated_atを更新
      @post.touch
      #未読ステータス登録処理
      users = User.where.not(id: @comment.user_id)
      users.each do |user|
        #既に未読ある人や、技師以外には未読付かないようにする処理
        same_unread = Unread.find_by(user_id: user.id, anonymous_post_id: @post.id)
        position_ids = user.positions.ids
        if same_unread.blank? && [1, 2, 3, 4].any? {|i| position_ids.include?(i)}
          unread = Unread.create(user_id: user.id, anonymous_post_id: @post.id)
        end
      end
      #コメントの通知処理
      @post.create_notification_comment!(@current_user, @comment.id)
      redirect_to anonymous_post_url(@post), notice: "コメントを投稿しました。"
    else
      render :new
    end
  end

  def destroy
    comment = AnonymousComment.find(params[:id])
    comment.destroy
    redirect_to anonymous_post_url(comment.anonymous_post), notice: "コメントを削除しました。"
  end

  private
    #管理者か確認
    def require_admin
        redirect_to anonymous_posts_url, notice: "権限がありません" unless current_user.admin?
    end
    #卒業生か確認
    def ensure_graduate
      if @current_user.position_ids.include?(5)
        redirect_to anonymous_posts_url, notice: "権限がありません"
      end
    end
    #ストロングパラメータ
    def comment_params
      params.require(:anonymous_comment).permit(:content, :anonymous_post_id, :nickname, :position)
    end

end
