class DevicesController < ApplicationController

  before_action :ensure_correct_user, {only: [:update, :destroy]}

  def index
    if params[:admin]
      @admin = true
      @user = User.find(params[:user_id])
      @devices = Device.where(user_id: params[:user_id]).order(created_at: "ASC")
    else
      @devices = Device.where(user_id: @current_user.id).order(created_at: "ASC")
    end
  end

  def show
    @device = Device.find(params[:id])
  end

  def new
    @device = Device.new
    @security_softs = SecuritySoft.all
  end

  def create
    @device = Device.new(device_params)
    @device.user_id = @current_user.id
    @guide = params[:device][:guide]
    if @device.save
      #ガイドフォームから来た場合はガイドフォームへリダイレクト
      if @guide
        redirect_to add_device_wifis_url, notice: "新しいデバイスを登録しました。"
      else
        redirect_to devices_url, notice: "新しいデバイスを登録しました。"
      end
    else
      @security_softs = SecuritySoft.all
      render :new
    end
  end

  def edit
    @device = Device.find(params[:id])
    @security_softs = SecuritySoft.all
  end

  def update
    @device = Device.find(params[:id])
    if @device.update(device_params)
      redirect_to @device, notice: "デバイスを編集しました。"
    else
      @security_softs = SecuritySoft.all
      render :edit
    end
  end

  def destroy
    device = Device.find(params[:id])
    device.destroy
    #ガイドフォームから来た場合はガイドフォームへリダイレクト
    if params[:guide]
      redirect_to release_device_wifis_url, notice: "デバイスを削除しました。"
    else
      redirect_to devices_url, notice: "デバイスを削除しました。"
    end
  end

  private

    #デバイス登録者本人か確認
    def ensure_correct_user
      @device = Device.find(params[:id])
      if @device.user_id != @current_user.id
        redirect_to wifis_url, notice: "権限がありません"
      end
    end

    #ストロングパラメータ
    def device_params
      params.require(:device).permit(:name, :os, :device_type, :manufacturer_id, :image, :security_soft_id, :owner)
    end


end
