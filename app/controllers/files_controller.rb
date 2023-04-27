class FilesController < ApplicationController
  before_action :ensure_graduate

  def index
  end

  private

    #卒業生か確認
    def ensure_graduate
      if @current_user.position_ids.include?(5)
        redirect_to index_url, notice: "権限がありません"
      end
    end

end
