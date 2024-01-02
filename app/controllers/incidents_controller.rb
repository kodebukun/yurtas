class IncidentsController < ApplicationController

  before_action :ensure_graduate, {only: [:new, :edit, :create, :update, :destroy]}

  def top
    @departments = Department.all.order(order: "ASC")
    @my_unreads = Unread.where(user_id: @current_user).where.not(incident_id: nil)
    @unchecked_incident = Incident.find_by(checked: false)
  end

  def check
    @incidents = Incident.where(checked: false).order(occurred_at: "DESC").page(params[:page]).per(10)
  end

  def checked_update
    @incident = Incident.find(params[:id])
    if params[:checked]
      @incident.update(checked: true)
      #未読ステータス登録処理
      users = User.where.not(id: @incident.user_id)
      users.each do |user|
        unread = Unread.create(user_id: user.id, incident_id: @incident.id)
      end
      redirect_to top_incidents_url, notice: "承認しました。"
    else
      @incident.update(checked: false)
      #未読ステータス削除処理
      unreads = Unread.where(incident_id: @incident.id)
      unreads.each do |unread|
        unread.destroy
      end
      redirect_to top_incidents_url, notice: "未承認に戻しました。"
    end
  end

  def index
    @department = Department.find(params[:department_id])
    @incidents = Incident.where(department_id: @department.id).order(occurred_at: "DESC").page(params[:page]).per(10)
  end

  def show
    @incident = Incident.find(params[:id])
    @department = @incident.department
    #未読解除処理
    unreads = Unread.where(user_id: @current_user.id, incident_id: @incident.id)
    unreads.each do |unread|
      unread.destroy
    end
  end

  def new
    @incident = Incident.new
    @departments = Department.all.order(order: "ASC")
  end

  def edit
    @incident = Incident.find(params[:id])
    @departments = Department.all.order(order: "ASC")
  end

  def create
    @incident = Incident.new(incident_params)
    @incident.user_id = @current_user.id
    if @incident.save
      redirect_to incident_url(@incident), notice: "新規投稿しました。"
    else
      @departments = Department.all.order(order: "ASC")
      render :new
    end
  end

  def update
    @incident = Incident.find(params[:id])
    if @incident.update(incident_params)
      redirect_to incident_url, notice: "投稿を編集しました。"
    else
      @departments = Department.all.order(order: "ASC")
      render :edit
    end
  end

  def destroy
    incident = Incident.find(params[:id])
    incident.destroy
    redirect_to incidents_url(department_id: incident.department.id), notice: "投稿を削除しました。"
  end

  private
    #ストロングパラメーター
    def incident_params
      params.require(:incident).permit(:shift, :occurred_at , :department_id, :place, :years, :target, :happened, :response, :measure, :excuse, :content, :title)
    end
    #卒業生か確認
    def ensure_graduate
      if @current_user.position_ids.include?(5)
        redirect_to incidents_url, notice: "権限がありません"
      end
    end

end
