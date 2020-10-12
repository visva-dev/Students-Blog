class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @categories = Category.all
    @articles = []
    @categories.each do |category|
      category.articles.each do |article|
        @articles << article
      end
    end
    @article = @articles.last


    cate = params[:cate]
    if !cate.nil?
      @articles = Article.where(:category_id => cate)
    else
      @articles = Article.order(created_at: :desc).includes(:user)
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
    redirect_to :action => :index
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

