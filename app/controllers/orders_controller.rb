class OrdersController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
    @orders = current_user.past_orders.paginate(page: params[:page], per_page: 30)
    @returns = current_user.returns
  end
  
  def show
    @order = current_user.past_orders.find_by(id: params[:id])
  end
  
end