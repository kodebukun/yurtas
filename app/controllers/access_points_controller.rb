class AccessPointsController < ApplicationController

  before_action :require_admin, {only: [:create, :update, :destroy, :admin]}

  def index
    @access_points = AccessPoint.all
  end

  def admin
    @access_points = AccessPoint.all
  end

  def show
    @access_point = AccessPoint.find(params[:id])
    if params[:admin]
      @admin = true
    end
    @registered_users = @access_point.users
    #登録端末の総数を求める処理
    @all_devices_count = 0
    @registered_users.each do |user|
      user_devices_count = user.devices.count
      @all_devices_count = @all_devices_count + user_devices_count
    end
  end

  def new
    @access_point = AccessPoint.new
    @inspection_rooms = InspectionRoom.all
  end

  def create
    @access_point = AccessPoint.new(access_point_params)
    if @access_point.save
      redirect_to access_points_url, notice: "新しいAPを登録しました。"
    else
      @inspection_rooms = InspectionRoom.all
      render :new
    end
  end

  def edit
    @access_point = AccessPoint.find(params[:id])
    @inspection_rooms = InspectionRoom.all
  end

  def update
    @access_point = AccessPoint.find(params[:id])
    if @access_point.update(access_point_params)
      redirect_to @access_point, notice: "APを編集しました。"
    else
      @inspection_rooms = InspectionRoom.all
      render :edit
    end
  end

  def destroy
    access_point = AccessPoint.find(params[:id])
    access_point.destroy
    redirect_to access_points_url, notice: "APを削除しました。"
  end

  private

    #管理者か確認
    def require_admin
      #Wi-Fi管理者、保吉13、新沼42、谷地21、佐藤凌47、大沼遼37
      if current_user.id != 13 && current_user.id != 21 && current_user.id != 42 && current_user.id != 47 && current_user.id != 37
        redirect_to access_points_url, notice: "権限がありません"
      end
    end

    #ストロングパラメータ
    def access_point_params
      params.require(:access_point).permit(:ssid, :password, :inspection_room_id)
    end


end
