class AttendancesController < ApplicationController
  before_action :check_specific_user, {only: [:new, :create]}

  def menu
  end

  def list
  end

  def ranking
    @users = User.where(call: true).includes(:ranking).order("rankings.rank ASC")
    @rankings = Ranking.all
  end

  def ranking_update
    if params[:bottom_user_id]
      ranking = User.find(params[:bottom_user_id].to_i).ranking
      higher_rankings = Ranking.where("rank > ?", ranking.rank)
      max_rank = Ranking.maximum(:rank)
      higher_rankings.each do |higher_ranking|
        higher_ranking.rank -= 1
        higher_ranking.save!
      end
      ranking.update!(rank: max_rank)
      redirect_to ranking_attendances_url, notice: "順位を更新しました"
    else
      ranking = User.find(params[:user_id].to_i).ranking
      if  ranking.rank > params[:rank].to_i
        change_rankings = Ranking.where(rank: params[:rank].to_i .. ranking.rank-1)
        change_rankings.each do |change_ranking|
          change_ranking.rank += 1
          change_ranking.save!
        end
        ranking.update!(rank: params[:rank].to_i)
        redirect_to ranking_attendances_url, notice: "順位を更新しました"
      elsif ranking.rank < params[:rank].to_i
        change_rankings = Ranking.where(rank: ranking.rank+1 .. params[:rank].to_i)
        change_rankings.each do |change_ranking|
          change_ranking.rank -= 1
          change_ranking.save!
        end
        ranking.update!(rank: params[:rank].to_i)
        redirect_to ranking_attendances_url, notice: "順位を更新しました"
      else
        redirect_to ranking_attendances_url, notice: "順位に変更はありません"
      end
    end
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

  private

    def check_specific_user
      if @current_user.id != 5
        redirect_to index_url, notice: "権限がありません"
      end
    end

end
