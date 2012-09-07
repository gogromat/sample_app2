class UsersController < ApplicationController
  def new
  end

  def create
  rescue ActiveRecord::StatementInvalid
    redirect_to root_path

  end
end
