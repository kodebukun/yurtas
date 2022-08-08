class LikesController < ApplicationController

  def create
    if params[:post_id]
      @like = Like.create!(user_id: @current_user.id, post_id: params[:post_id])
      #投稿へイイネへの通知処理
      @like.post.create_notification_like!(@current_user)
      redirect_to post_url(@like.post)
    elsif params[:comment_id]
      @like = Like.create!(user_id: @current_user.id, comment_id: params[:comment_id])
      #コメントへイイネへの通知処理
      @like.comment.create_notification_like!(@current_user)
      if @like.comment.post
        redirect_to post_url(@like.comment.post)
      elsif @like.comment.morning
        redirect_to morning_url(@like.comment.morning)
      elsif @like.comment.diary
        redirect_to diary_url(@like.comment.diary)
      end
    elsif params[:morning_id]
      @like = Like.create!(user_id: @current_user.id, morning_id: params[:morning_id])
      #朝投稿へイイネへの通知処理
      @like.morning.create_notification_like!(@current_user)
      redirect_to morning_url(@like.morning)
    elsif params[:diary_id]
      @like = Like.create!(user_id: @current_user.id, diary_id: params[:diary_id])
      #宿直日誌投稿へイイネへの通知処理
      @like.diary.create_notification_like!(@current_user)
      redirect_to diary_url(@like.diary)
    elsif params[:anonymous_comment_id]
      @like = Like.create!(user_id: @current_user.id, anonymous_comment_id: params[:anonymous_comment_id])
      #匿名投稿へイイネへの通知処理
      @like.anonymous_comment.create_notification_like!(@current_user)
      redirect_to anonymous_post_url(@like.anonymous_comment.anonymous_post)
    end
  end

  def destroy
    if params[:post_id]
      @like = Like.find_by(user_id: @current_user.id, post_id: params[:post_id])
      @like.destroy
      redirect_to post_url(@like.post)
    elsif params[:comment_id]
      @like = Like.find_by(user_id: @current_user.id, comment_id: params[:comment_id])
      @like.destroy
      if @like.comment.post
        redirect_to post_url(@like.comment.post)
      elsif @like.comment.morning
        redirect_to morning_url(@like.comment.morning)
      elsif @like.comment.diary
        redirect_to diary_url(@like.comment.diary)
      end
    elsif params[:morning_id]
      @like = Like.find_by(user_id: @current_user.id, morning_id: params[:morning_id])
      @like.destroy
      redirect_to morning_url(@like.morning)
    elsif params[:diary_id]
      @like = Like.find_by(user_id: @current_user.id, diary_id: params[:diary_id])
      @like.destroy
      redirect_to diary_url(@like.diary)
    elsif params[:anonymous_comment_id]
      @like = Like.find_by(user_id: @current_user.id, anonymous_comment_id: params[:anonymous_comment_id])
      @like.destroy
      redirect_to anonymous_post_url(@like.anonymous_comment.anonymous_post)
    end
  end

end
