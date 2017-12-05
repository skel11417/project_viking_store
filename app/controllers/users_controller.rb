class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all.includes(:shipping_address)
  end

  def order_history

  end

end
