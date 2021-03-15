class AttendancesController < ApplicationController

  def menu
  end

  def list
  end

  def ranking
  end

  def roster
  end

  def new
  end

  def create
    file = params[:file]
    File.binwrite("public/attendances_pdf/1_list.pdf", file.read)
    redirect_to index_url, notice: "当直表を登録しました。"
  end

end
