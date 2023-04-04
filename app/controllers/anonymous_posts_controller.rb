class AnonymousPostsController < ApplicationController
  before_action :require_admin, {only: [:destroy]}
  before_action :ensure_correct_user, {only: [:update]}
  before_action :ensure_graduate, {only: [:new, :create, :update, :destroy]}

  def index
    if params[:sort] == "comment"
      #コメント数が多い順でpostを取得。このコードだとcommentが0のpostは取得できなかった。
      #.group(:anonymous_post_id)：同じ:anonymous_post_idでグループ化
      #.order(Arel.sql("count(anonymous_post_id) desc"))：anonymous_post_idの数の多い順に並び替え。
      #Rails6.0からは、orderの中にSQLを直書きしてはいけないので、Arel.sqlで囲む。
      #.pluck(:anonymous_post_id)：pluckで要素を取り出す
      @posts = AnonymousPost.find(AnonymousComment.group(:anonymous_post_id).order(Arel.sql("count(anonymous_post_id) desc")).pluck(:anonymous_post_id))
      #.paginate_array(@posts):オブジェクトじゃなく、配列に対してpaginateするときはこちらを使う。
      @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(10)
    elsif params[:sort] == "good"
      #good数が多い順でpostを取得。このコードだとgoodが0のpostは取得できなかった。
      @posts = AnonymousPost.find(Evaluation.group(:anonymous_post_id).where(agreement: true).order(Arel.sql("count(anonymous_post_id) desc")).pluck(:anonymous_post_id))
      @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(10)
    else
      @posts = AnonymousPost.all.order(updated_at: "DESC").page(params[:page]).per(10)
    end
  end

  def show
    @post = AnonymousPost.find(params[:id])
    @comments = @post.anonymous_comments.order(created_at: "DESC")
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
    if params[:resolved] == "true"
      @post.update(resolved: true, discuss: false)
      redirect_to anonymous_post_url(@post), notice: "解決済みにしました。"
    elsif params[:resolved] == "false"
      @post.update(resolved: false)
      redirect_to anonymous_post_url(@post), notice: "未解決にしました。"
    elsif params[:discuss] == "true"
      @post.update(resolved: false, discuss: true)
      redirect_to anonymous_post_url(@post), notice: "会議中にしました。"
    elsif params[:discuss] == "false"
      @post.update(discuss: false)
      redirect_to anonymous_post_url(@post), notice: "会議中を解除しました。"
    end
  end

  def destroy
    post = AnonymousPost.find(params[:id])
    post.destroy
    redirect_to anonymous_posts_url, notice: "投稿を削除しました。"
  end

  private

    #管理者か確認
    def require_admin
        redirect_to anonymous_posts_url, notice: "権限がありません" unless current_user.admin?
    end
    #投稿者本人か確認
    def ensure_correct_user
      @post = AnonymousPost.find(params[:id])
      if @post.user_id != @current_user.id
        redirect_to anonymous_posts_url, notice: "権限がありません"
      end
    end
    #卒業生か確認
    def ensure_graduate
      if @current_user.positions[0].name == "卒業生"
        redirect_to anonymous_posts_url, notice: "権限がありません"
      end
    end
    #ストロングパラメータ
    def post_params
      params.require(:anonymous_post).permit(:title, :content, :resolved)
    end

end
