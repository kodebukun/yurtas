class MaterialsController < ApplicationController

  before_action :require_admin, {only: [:destroy]}

  def index
  end

  def machines
    @cr = Material.where(material_type: "machine", department_id: 1).order(id: "ASC")
    @ct = Material.where(material_type: "machine", department_id: 2).order(id: "ASC")
    @mri = Material.where(material_type: "machine", department_id: 3).order(id: "ASC")
    @xa = Material.where(material_type: "machine", department_id: 4).order(id: "ASC")
    @ri = Material.where(material_type: "machine", department_id: 5).order(id: "ASC")
    @rt = Material.where(material_type: "machine", department_id: 6).order(id: "ASC")
  end

  def phantoms
    @cr = Material.where(material_type: "phantom", department_id: 1)
    @ct = Material.where(material_type: "phantom", department_id: 2)
    @mri = Material.where(material_type: "phantom", department_id: 3)
    @xa = Material.where(material_type: "phantom", department_id: 4)
    @ri = Material.where(material_type: "phantom", department_id: 5)
    @rt = Material.where(material_type: "phantom", department_id: 6)
  end

  def dosimeters
    @cr = Material.where(material_type: "dosimeter", department_id: 1)
    @ct = Material.where(material_type: "dosimeter", department_id: 2)
    @mri = Material.where(material_type: "dosimeter", department_id: 3)
    @xa = Material.where(material_type: "dosimeter", department_id: 4)
    @ri = Material.where(material_type: "dosimeter", department_id: 5)
    @rt = Material.where(material_type: "dosimeter", department_id: 6)
  end

  def new
    @material = Material.new
    @manufacturers = Manufacturer.all
    @departments = Department.all
  end

  def edit
    @material = Material.find(params[:id])
    @manufacturers = Manufacturer.all
    @departments = Department.all
  end

  def create
    @material = Material.new(material_params)
    if @material.save
      redirect_to materials_url, notice: "新しい機器を登録しました。"
    else
      @manufacturers = Manufacturer.all
      @departments = Department.all
      render :new
    end
  end

  def update
    @material = Material.find(params[:id])
    if @material.update(material_params)
      redirect_to materials_url, notice: "機器情報を更新しました。"
    else
      @manufacturers = Manufacturer.all
      @departments = Department.all
      render :edit
    end
  end

  def destroy
    material = Material.find(params[:id])
    material.destroy
    redirect_to materials_url, notice: "機器を削除しました。"
  end

  private

    #管理者か確認
    def require_admin
        redirect_to materials_url, notice: "権限がありません" unless current_user.admin?
    end

    #ストロングパラメータ
    def material_params
      params.require(:material).permit(:name, :place, :use, :manufacturer_id, :image, :install_date, :update_date, :material_type, :department_id)
    end

end
