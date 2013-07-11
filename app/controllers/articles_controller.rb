class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.find(:all, :order => "citations_page_rank desc", :limit => 11)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  def display
    @articles = Article.find(:all, :order => "citations_page_rank desc", :limit => 30)

    children  = []
    @articles.each do |article|
      child = {}
      child[:size] = (article.citations_page_rank * 10000).to_i
      child[:name] =  article.title
      children << child
    end

    response = {
      "name" => "page_rank",
      "children" => children
    }

    respond_to do |format|
      format.html {render :layout => false}
      format.json { render json: response.to_json(:methods => [:name,:size]) }
    end
  end

end
