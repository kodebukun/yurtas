class EvaluationsController < ApplicationController

  def create
    @evaluation = Evaluation.create!(user_id: @current_user.id, anonymous_post_id: params[:anonymous_post_id], agreement: params[:agreement])
    redirect_to anonymous_post_url(@evaluation.anonymous_post)
  end

  def update
    @evaluation = Evaluation.find_by(user_id: @current_user.id, anonymous_post_id: params[:anonymous_post_id])
    if @evaluation.agreement == true
      @evaluation.agreement = false
    else
      @evaluation.agreement = true
    end
    @evaluation.save!
    redirect_to anonymous_post_url(@evaluation.anonymous_post)
  end

  def destroy
    @evaluation = Evaluation.find_by(user_id: @current_user.id, anonymous_post_id: params[:anonymous_post_id])
    @evaluation.destroy
    redirect_to anonymous_post_url(@evaluation.anonymous_post)
  end

end
