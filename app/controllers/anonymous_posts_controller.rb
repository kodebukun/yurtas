class AnonymousPostsController < ApplicationController
  before_action :ensure_administrator, {only: [:destroy]}
  before_action :ensure_correct_user, {only: [:update]}

  def index
    if params[:sort] == "comment"
      #コメント数が多い順でpostを取得
      @posts = AnonymousPost.where(id: AnonymousComment.group(:anonymous_post_id).order("count(anonymous_post_id) desc").pluck(:anonymous_post_id)).page(params[:page]).per(10)
    elsif params[:sort] == "good"
      #good数が多い順でpostを取得。このコードだとgoodが0のpostは取得できなかった。
      @posts = AnonymousPost.where(id: Evaluation.where(agreement: true).group(:anonymous_post_id).order("count(anonymous_post_id) desc").pluck(:anonymous_post_id)).page(params[:page]).per(10)
    else
      @posts = AnonymousPost.all.order(updated_at: "DESC").page(params[:page]).per(10)
    end
  end

  def show
    @post = AnonymousPost.find(params[:id])
    @comments = @post.anonymous_comments.order(created_at: "ASC")
    @good_count = @post.evaluations.where(agreement: true).count
    @bad_count = @post.evaluations.where(agreement: false).count
    total_evaluation_count = @post.evaluations.count
    if total_evaluation_count == 0
      @good_percentage = 0
      @bad_percentage = 0
    else
      @good_percentage = @good_count / total_evaluation_count.to_f * 100
      @bad_percentage = 100 - @good_percentage.to_i
    end
    #未読解除処理
    unread = Unread.find_by(user_id: @current_user.id, anonymous_post_id: @post.id)
    if unread.present?
      unread.destroy
    end
  end

  def new
    @post = AnonymousPost.new
  end

  def create
    @post = AnonymousPost.new(post_params)
    @post.user_id = @current_user.id
    if @post.save
      #未読ステータス登録処理
      users = User.where.not(id: @post.user_id)
      users.each do |user|
        unread = Unread.create(user_id: user.id, anonymous_post_id: @post.id)
      end
      redirect_to anonymous_post_url(@post), notice: "新規投稿しました。"
    else
      render :new
    end
  end

  def update
    @post = AnonymousPost.find(params[:id])
    @post.update(resolved: params[:resolved])
    if @post.resolved == true
      redirect_to anonymous_post_url(@post), notice: "解決済みにしました。"
    else
      redirect_to anonymous_post_url(@post), notice: "未解決にしました。"
    end
  end

  def destroy
    post = AnonymousPost.find(params[:id])
    post.destroy
    redirect_to anonymous_posts_url, notice: "投稿を削除しました。"
  end

  private

    #管理人か確認
    def ensure_administrator
      if @current_user.id != 21
        redirect_to anonymous_posts_url, notice: "権限がありません"
      end
    end
    #投稿者本人か確認
    def ensure_correct_user
      @post = AnonymousPost.find(params[:id])
      if @post.user_id != @current_user.id
        redirect_to anonymous_posts_url, notice: "権限がありません"
      end
    end
    #ストロングパラメータ
    def post_params
      params.require(:anonymous_post).permit(:title, :content, :resolved)
    end

end
