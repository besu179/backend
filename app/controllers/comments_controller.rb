class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :destroy]
  before_action :authorize_user, only: [:create, :destroy]

  # GET /comments
  def index
    @comments = Comment.all
    render json: @comments
  end

  # GET /comments/:id
  def show
    render json: @comment
  end

  # POST /comments
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /comments/:id
  def destroy
    if @comment.user == current_user
      @comment.destroy
      render json: { message: "Comment deleted" }
    else
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end

  def authorize_user
    render json: { error: "Not logged in" }, status: :unauthorized unless current_user
  end

  # Stub for current_user (replace with real session logic)
  def current_user
    User.find_by(id: session[:user_id])
  end
end
