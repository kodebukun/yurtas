class DiariesController < ApplicationController

  before_action :ensure_correct_user, {only: [:update, :destroy]}

  def index
    if params[:month]
      @month = Date.parse(params[:month])
    elsif params["month(1i)"] && params["month(2i)"]
      @month = Date.parse("#{params["month(1i)"]}/#{params["month(2i)"]}/#{params["month(3i)"]}")
    else
      @month = Time.zone.today
    end
    @monthly_diaries = Diary.where(designated_date: @month.all_month).order(designated_date: "DESC").page(params[:page]).per(10)
  end

  def show
    @diary = Diary.find(params[:id])
    @comments = @diary.comments.order(created_at: "ASC")
  end

  def new
    @diary = Diary.new
  end

  def edit
    @diary = Diary.find(params[:id])
  end

  def create
    @diary = Diary.new(diary_params)
    @diary.user_id = @current_user.id
    if @diary.save
      #新規投稿の通知処理
      @diary.save_notification_post!(@current_user)
      redirect_to diary_url(@diary), notice: "新規投稿しました。"
    else
      render :new
    end
  end

  def update
    @diary = Diary.find(params[:id])
    if @diary.update(diary_params)
      redirect_to diary_url, notice: "投稿を編集しました。"
    else
      render :edit
    end
  end

  def destroy
    diary = Diary.find(params[:id])
    diary.destroy
    redirect_to diaries_url, notice: "投稿を削除しました。"
  end


  private

    #投稿者本人か確認
    def ensure_correct_user
      @diary = Diary.find(params[:id])
      if @diary.user_id != @current_user.id
        redirect_to diaries_url, notice: "権限がありません"
      end
    end
    #ストロングパラメータ
    def diary_params
      params.require(:diary).permit(:title, :content, :designated_date, :partner_id)
    end


end
