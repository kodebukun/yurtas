class LikesController < ApplicationController

  def create
    if params[:post_id].present? && params[:comment_id].blank? && params[:morning_id].blank?
      @like = Like.create!(user_id: @current_user.id, post_id: params[:post_id])
      #投稿へイイネへの通知処理
      @like.post.create_notification_like!(@current_user)
      redirect_to post_url(@like.post)
    elsif params[:post_id].blank? && params[:comment_id].present? && params[:morning_id].blank?
      @like = Like.create!(user_id: @current_user.id, comment_id: params[:comment_id])
      #コメントへイイネへの通知処理
      @like.comment.create_notification_like!(@current_user)
      if @like.comment.post
        redirect_to post_url(@like.comment.post)
      else
        redirect_to morning_url(@like.comment.morning)
      end
    elsif params[:post_id].blank? && params[:comment_id].blank? && params[:morning_id].present?
      @like = Like.create!(user_id: @current_user.id, morning_id: params[:morning_id])
      #朝投稿へイイネへの通知処理
      @like.morning.create_notification_like!(@current_user)
      redirect_to morning_url(@like.morning)
    end
  end

  def destroy
    if params[:post_id].present? && params[:comment_id].blank? && params[:morning_id].blank?
      @like = Like.find_by(user_id: @current_user.id, post_id: params[:post_id])
      @like.destroy
      redirect_to post_url(@like.post)
    elsif params[:post_id].blank? && params[:comment_id].present? && params[:morning_id].blank?
      @like = Like.find_by(user_id: @current_user.id, comment_id: params[:comment_id])
      @like.destroy
      if @like.comment.post
        redirect_to post_url(@like.comment.post)
      else
        redirect_to morning_url(@like.comment.morning)
      end
    elsif params[:post_id].blank? && params[:comment_id].blank? && params[:morning_id].present?
      @like = Like.find_by(user_id: @current_user.id, morning_id: params[:morning_id])
      @like.destroy
      redirect_to morning_url(@like.morning)
    end
  end

end
