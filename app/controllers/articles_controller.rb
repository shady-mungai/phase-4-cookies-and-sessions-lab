class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  #before_action :reset_page_views, only: [:show]

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show

    # cookies[:views] ||= 0
    # cookies[:views] = cookies[:views].to_i + 1 
    # cookies[:views].to_i + 1
    session[:page_views] ||= 0
    session[:page_views] += 1
     
    article = Article.find(params[:id])

    if session[:page_views] <= 3
    render json: article
    else 
      render json: { error: "Unauthorized "}, status: :unauthorized
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  # def reset_page_views
  #   session[:page_views] = 0
  # end



end