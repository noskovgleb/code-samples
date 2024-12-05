module Api
  module V1
    class ArticlesController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_article, only: [:show, :update, :destroy]

      def index
        @articles = Article.all
        render json: @articles
      end

      def show
        render json: @article
      end

      def create
        @article = current_user.articles.build(article_params)
        
        if @article.save
          render json: @article, status: :created
        else
          render json: { errors: @article.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @article.update(article_params)
          render json: @article
        else
          render json: { errors: @article.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @article.destroy
        head :no_content
      end

      private

      def set_article
        @article = Article.find(params[:id])
      end

      def article_params
        params.require(:article).permit(:title, :content, :published)
      end
    end
  end
end