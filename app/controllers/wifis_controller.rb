class WifisController < ApplicationController

  before_action :ensure_graduate, {only: [:add_device, :release_device]}

  def index
  end

  def add_device
    @devices = Device.where(user_id: @current_user.id).order(created_at: "ASC")
  end

  def release_device
    @devices = Device.where(user_id: @current_user.id).order(created_at: "ASC")
  end

  private

    #卒業生か確認
    def ensure_graduate
      if @current_user.position_ids.include?(5)
        redirect_to wifis_url, notice: "権限がありません"
      end
    end

end
