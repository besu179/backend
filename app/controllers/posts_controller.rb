class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:create, :update, :destroy, :my_posts]

  # GET /posts
  def index
    @posts = Post.includes(:user).all
    render json: @posts, include: :user
  end

  # GET /posts/:id
  def show
    render json: @post, include: [:user, :comments]
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/:id
  def update
    if @post.user == current_user
      if @post.update(post_params)
        render json: @post
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  # DELETE /posts/:id
  def destroy
    if @post.user == current_user
      @post.destroy
      render json: { message: "Post deleted" }
    else
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  # GET /my_posts
  def my_posts
    @posts = current_user.posts
    render json: @posts
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def authorize_user
    render json: { error: "Not logged in" }, status: :unauthorized unless current_user
  end

  # Stub for current_user (replace with real session logic)
  def current_user
    User.find_by(id: session[:user_id])
  end
end
