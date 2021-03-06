class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    search_query = params[:query]

    if search_query.blank?
      @articles = Article.all
    else
      #sumeet's old way:
      # @articles = Article.where(:name => search_query)
      #sumeet's new way:
      # @articles = Article.where("name ilike :q", :q => "%#{search_query}%")
      #sumeet's second new way:
      # @articles = Article.where("name ilike :q or content ilike :q", :q => "%#{search_query}%")
      #third way:
      # @articles = Article.where("name @@ :q or content @@ :q", :q => "%#{search_query}%")
      #solr way1:
      # search = Article.search{fulltext(search_query)}
      # solr way2 (doesn't work here):
      search = Article.search do
        fulltext search_query
        with :author_id, params[:author_id]
      end
      @articles = search.results
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])
    @comments = @article.comments

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end
end
