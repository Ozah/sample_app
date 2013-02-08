class UsersController < ApplicationController
  #the before filter applies only to the "edit" and "update" actions
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  before_filter :signed_in_user_filter, only: [:new, :create]

  # GET /users  users_path
  def index
    @users = User.paginate(page: params[:page])
  end

  # GET /users/1  user_path(user)
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new  new_user_path
  def new
    @user = User.new
  end

  # POST /users users_path
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end

  end

  # GET /users/1/edit edit_user_path(user)
  def edit
  end

  # PUT /users/1  user_path(user)
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  # DELETE /users/1 user_path(user)
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
    #
    #user_to_destroy = User.find(params[:id])
    #current_user = User.find(params[:user])
    #if current_user != user_to_destroy
    #  user_to_destroy.destroy
    #  flash[:success] = "User destroyed."
    #  redirect_to users_url
    #else
    #  redirect_to(root_path)
    #end
  end

  private

    def signed_in_user
      unless signed_in?
        store_location #friendly forwarding
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      unless current_user.admin? && current_user != User.find(params[:id])
        redirect_to(root_path)
      end
      #redirect_to(root_path) unless current_user.admin?
    end

    def signed_in_user_filter
      redirect_to root_path, notice: "Already logged in." if signed_in?
    end
end
