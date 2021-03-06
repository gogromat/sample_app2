class UsersController < ApplicationController

  before_filter :signed_in_user,     only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :not_signed_in_user, only: [:new, :create]
  before_filter :correct_user,       only: [:edit, :update]
  before_filter :admin_user,         only: [:destroy]


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
      @user = User.find(params[:id])
      @microposts = @user.microposts.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

   def edit
    @user = User.find(params[:id])
   end

  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user?(@user) && @user.admin?
      flash[:error] = "Admin users cannot delete themselves"
    else
      @user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def not_signed_in_user
      if signed_in?
        redirect_to root_path, notice: "Already signed in. Sign out and try again."
      end
    end

end
