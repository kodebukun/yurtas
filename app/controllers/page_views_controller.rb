class PageViewsController < ApplicationController
  before_action :require_admin

  def index
    @page_views = PageView.includes(:user).order(updated_at: "DESC")

    if params[:date].present?
      date = Date.parse(params[:date]) rescue nil
      @page_views = @page_views.where(updated_at: date.beginning_of_day..date.end_of_day) if date
    elsif params[:month].present?
      month = Date.parse("#{params[:month]}-01") rescue nil
      @page_views = @page_views.where(updated_at: month.beginning_of_month..month.end_of_month) if month
    end

    @page_views = @page_views.page(params[:page]).per(30)
  end
end
