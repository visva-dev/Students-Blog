class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :require_same_user, only: %i[edit update destroy]

  def index
    @categories = Category.all
    cate = params[:cate]
    @articles = if !cate.nil?
                  Article.where(category_id: cate).includes([:category]).includes([:user]).order(created_at: :desc)
                    .paginate(page: params[:page], per_page: 6)
                else
                  @articles = Article.order(created_at: :desc)
                    .includes([:category]).includes([:user]).paginate(page: params[:page], per_page: 6)
                end
  end

  def show; end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to @article
    else
      render :new
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to articles_path
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to action: :index
  end

  def feature_articles
    @articles = Article.likes.count.order('created_at DESC')
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :category_id, :image)
  end

  def require_same_user
    return unless current_user != @article.user

    flash[:alert] = 'You can only edit or delete your own article'
    redirect_to @article
  end
end
