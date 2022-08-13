class BreachesController < ApplicationController

  #before_action :ensure_specific_user, {only: [:index, :show, :update, :destroy]}

  def index
    @breachs = Breach.where(checked: false).order(created_at: "DESC").page(params[:page]).per(10)
  end

  def show
    @breach = Breach.find(params[:id])
  end

  def new
    @breach = Breach.new
    if params[:anonymous_post_id]
      @post = AnonymousPost.find(params[:anonymous_post_id])
    elsif params[:anonymous_comment_id]
      @comment = AnonymousComment.find(params[:anonymous_comment_id])
    end
  end

  def create
    @breach = Breach.new(breach_params)
    @breach.user_id = @current_user.id
    if @breach.save
      if @breach.anonymous_post
        post = @breach.anonymous_post
        post.update(safety: "judging")
        redirect_to anonymous_post_url(@breach.anonymous_post), notice: "違反を報告しました。"
      elsif @breach.anonymous_comment
        comment = @breach.anonymous_comment
        comment.update(safety: "judging")
        redirect_to anonymous_post_url(@breach.anonymous_comment.anonymous_post), notice: "違反を報告しました。"
      end
    else
      render :new
    end
  end

  def update
    @breach = Breach.find(params[:id])
    @breach.update(approval: params[:approval])
    @breach.checked = true
    @breach.save
    if @breach.approval == true
      if @breach.anonymous_post
        post = @breach.anonymous_post
        post.safety = "danger"
        post.save!
      elsif @breach.anonymous_comment
        comment = @breach.anonymous_comment
        comment.safety = "danger"
        comment.save!
      end
      redirect_to breaches_url, notice: "違反報告を承認しました。"
    else
      if @breach.anonymous_post
        post = @breach.anonymous_post
        post.safety = "safe"
        post.save!
      elsif @breach.anonymous_comment
        comment = @breach.anonymous_comment
        comment.safety = "safe"
        comment.save!
      end
      redirect_to breaches_url, notice: "違反報告を却下しました。"
    end
  end

  def destroy
    breach = Breach.find(params[:id])
    breach.destroy
    redirect_to breaches_url, notice: "違反報告を削除しました。"
  end

  private

    #特定Userか確認
    def ensure_specific_user
      if !(@current_user.id == 13 || @current_user.id == 21)
        redirect_to index_url, notice: "権限がありません"
      end
    end
    #ストロングパラメータ
    def breach_params
      params.require(:breach).permit(:content, :approval, :anonymous_post_id, :anonymous_comment_id)
    end

end
