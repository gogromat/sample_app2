class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def index

  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url          #302
    else
      #flash.new
      @feed_items = []
      render 'static_pages/home'    #200
    end
  end

  def destroy
    puts @micropost
    @micropost.destroy
    redirect_to root_url
  end

  private

    def correct_user
        @micropost = current_user.microposts.find_by_id(params[:id])
      rescue
        redirect_to root_url #if  @micropost.nil?
    end

end