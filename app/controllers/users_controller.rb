class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: [:destroy]


  def new
    @user = User.new
  end

  def create
    #rescue ActiveRecord::StatementInvalid
    #redirect_to root_path
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
      # /users/1      show      GET   user_path(user)
      @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

   def edit
    @user = User.find(params[:id])
   end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:sucess] = "User destroyed."
    redirect_to users_url
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
      #flash[:notice] = "Please sign in."
      #redirect_to signin_url
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
