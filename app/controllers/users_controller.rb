class UsersController < ApplicationController
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

  end

end
