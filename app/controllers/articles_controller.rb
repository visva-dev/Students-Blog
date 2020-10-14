class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @categories = Category.all
    cate = params[:cate]
    @articles = if !cate.nil?
                  Article.where(category_id: cate).includes([:user]).paginate(page: params[:page], per_page: 3)
                else
                  @articles = Article.order(created_at: :desc).includes(:user)
                            .includes([:user]).paginate(page: params[:page], per_page: 3)
                end
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])

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
end
