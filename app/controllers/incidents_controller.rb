class IncidentsController < ApplicationController

  before_action :ensure_graduate, {only: [:new, :edit, :create, :update, :destroy]}

  def top
    @departments = Department.all
  end

  def index
    @department = Department.find(params[:department_id])
    @incidents = Incident.where(department_id: @department.id).order(occurred_at: "DESC").page(params[:page]).per(10)
  end

  def show
    @incident = Incident.find(params[:id])
    @department = @incident.department
  end

  def new
    @incident = Incident.new
    @departments = Department.all
  end

  def edit
    @incident = Incident.find(params[:id])
    @departments = Department.all
  end

  def create
    @incident = Incident.new(incident_params)
    if @incident.save
      redirect_to incident_url(@incident), notice: "新規投稿しました。"
    else
      @departments = Department.all
      render :new
    end
  end

  def update
    @incident = Incident.find(params[:id])
    if @incident.update(incident_params)
      redirect_to incident_url, notice: "投稿を編集しました。"
    else
      @departments = Department.all
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
      params.require(:incident).permit(:shift, :occurred_at , :department_id, :place, :years, :target, :happened, :response, :measure, :excuse)
    end
    #卒業生か確認
    def ensure_graduate
      if @current_user.position_ids.include?(5)
        redirect_to incidents_url, notice: "権限がありません"
      end
    end

end
