class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy ]

  # GET /comments or /comments.json
  def index
    # @comments = Comment.all
    @article = Article.find(params[:article_id])

    # Access all comments of that article
    @comments = @article.comments
    @uaer = current_user
  end

  # GET /comments/1 or /comments/1.json
  def show
    @article = Article.find(params[:article_id])
    # For URL like /articles/1/reviws/2
    # Find an comment in articles 1 that has id=2
    @comment = @article.comments.find(params[:id])
  end

  # GET /comments/new
  def new
    # @comment = Comment.new
    @article = Article.find(params[:article_id])

    # Associate an comment object with article 1
    @comment = @article.comments.build
  end

  # GET /comments/1/edit
  def edit
    @article = Article.find(params[:article_id])
    # For URL like /articles/1/comments/2/edit
    # Get comment id=2 for article 1
    @comment = @article.comments.find(params[:id])
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|

    @article = Article.find(params[:article_id])
    # For URL like /articles/1/s
    # Populate an comment associate with article 1 with form data
    # article will be associated with the comment
    # @comment = @article.comments.build(params.require(:comment).permit!)
    @comment = @article.comments.build(params.require(:comment).permit(:details))

    @comment.user = current_user
      if @comment.save
        format.html { redirect_to article_comment_url(@article, @comment), notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end

    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      @article = Article.find(params[:article_id])
      @comment = Comment.find(params[:id])

      if @comment.update(comment_params)
        format.html { redirect_to article_comment_url(@article, @comment), notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end

    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])

    @comment.destroy
    respond_to do |format|
      # format.html { redirect_to comments_url, notice: "Comment was successfully destroyed." }
      format.html { redirect_to article_path(@article), notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:details)
    end
end
