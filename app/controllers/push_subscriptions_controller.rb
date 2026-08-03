class PushSubscriptionsController < ApplicationController
  def create
    subscription = current_user.push_subscriptions.find_or_initialize_by(endpoint: params[:endpoint])
    subscription.assign_attributes(p256dh: params[:p256dh], auth: params[:auth])
    if subscription.save
      render json: { status: 'ok' }, status: :created
    else
      render json: { status: 'error' }, status: :unprocessable_entity
    end
  end

  def destroy
    subscription = current_user.push_subscriptions.find_by(endpoint: params[:endpoint])
    subscription&.destroy
    render json: { status: 'ok' }
  end
end
