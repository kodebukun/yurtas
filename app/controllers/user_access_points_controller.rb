class UserAccessPointsController < ApplicationController

  before_action :ensure_graduate

  def edit
    @user = User.find(@current_user.id)
    @access_points = AccessPoint.all
    @inspection_rooms = InspectionRoom.all
    @rd_staff_room = AccessPoint.find(1)
    @rd_staff_room5g = AccessPoint.find(2)
    @rd_lounge = AccessPoint.find(3)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_access_point_params_check_boxes)
      redirect_to access_points_url, notice: "設定を更新しました"
    else
      @access_points = AccessPoint.all
      render :edit
    end
  end

  def destroy
  end

  private

    #卒業生か確認
    def ensure_graduate
      if @current_user.positions[0].name == "卒業生"
        redirect_to wifis_url, notice: "権限がありません"
      end
    end

    #ストロングパラメーター
    def user_access_point_params_check_boxes
      params.require(:user).permit(access_point_ids: [])
    end


end
