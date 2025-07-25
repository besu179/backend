class UsersController < ApplicationController
  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      render json: { message: "Logged in", user: @user }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  # DELETE /logout
  def logout
    session[:user_id] = nil
    render json: { message: "Logged out" }
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    render json: @user
  end

  # PATCH/PUT /users/:id
  def update
    @user = User.find(params[:id])
    if @user == current_user
      if @user.update(user_params)
        render json: @user
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  # DELETE /users/:id
  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      @user.destroy
      session[:user_id] = nil
      render json: { message: "User deleted" }
    else
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Stub for current_user (replace with real session logic)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
