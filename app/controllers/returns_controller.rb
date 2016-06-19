class ReturnsController < ApplicationController
  before_action :authenticate_user!

  def new
    @return = Return.new(order_id: params[:order_id], user_id: current_user.id)
    @return.order.line_items.each do |line_item|
      @return.return_items.build(line_item_id: line_item.id)
    end
  end

  def create
    @return = Return.new(return_params)
    @return.generate_rma_code
    if @return.save
      redirect_to order_return_path(@return.order, @return), notice: "Your return was successfully submitted."
    else
      @return.order.line_items.each do |line_item|
        @return.return_items.build(line_item_id: line_item.id)
      end
      render 'new'
    end
  end

  def show
    @return = Return.find_by(order_id: params[:order_id], id: params[:id])
    respond_to do |format|
      format.html
      format.pdf
    end
  end

  private

  def return_params
    params.require(:return).permit(:order_id,
                                   :reason,
                                   :user_id,
                                   :status,
                                   :return_items_attributes => [
                                     :chosen,
                                     :line_item_id,
                                     :quantity
                                   ])
  end
end
