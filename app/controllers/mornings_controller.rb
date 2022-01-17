class MorningsController < ApplicationController
  before_action :ensure_correct_user, {only: [:update, :destroy]}


  def index
    @mornings = Morning.all.order(created_at: "DESC").page(params[:page]).per(10)
  end

  def print
  end

  def print_selected
    @week = %w[日曜日 月曜日 火曜日 水曜日 木曜日 金曜日 土曜日]
    if params[:start].present? && params[:end].present?
      @mornings = Morning.where(created_at: params[:start].to_date .. params[:end].to_date.tomorrow).order(created_at: "ASC")
    else
      redirect_to mornings_print_url, notice: "日付を入力して下さい。"
    end
  end

  def show
    @morning = Morning.find(params[:id])
    @comments = @morning.comments.order(created_at: "ASC")
  end

  def new
    @morning = Morning.new
    @week = %w[(日) (月) (火) (水) (木) (金) (土)]
  end

  def edit
    @morning = Morning.find(params[:id])
  end

  def create
    @morning = Morning.new(morning_params)
    @morning.user_id = @current_user.id
    if @morning.save
      redirect_to morning_url(@morning), notice: "新規投稿しました。"
    else
      render :new
    end
  end

  def update
    @morning = Morning.find(params[:id])
    if @morning.update(morning_params)
      redirect_to morning_url, notice: "投稿を編集しました。"
    else
      render :edit
    end
  end

  def destroy
    morning = Morning.find(params[:id])
    morning.destroy
    redirect_to mornings_url, notice: "投稿を削除しました。"
  end

  private

    #投稿者本人か確認
    def ensure_correct_user
      @morning = Morning.find(params[:id])
      if @morning.user_id != @current_user.id
        redirect_to mornings_url, notice: "権限がありません"
      end
    end
    #ストロングパラメータ
    def morning_params
      params.require(:morning).permit(:title, :content, :absentee)
    end

end
