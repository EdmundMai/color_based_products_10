class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.in_progress_or_shipped.paginate(page: params[:page], per_page: 30)
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(order_params)
      redirect_to admin_order_path(@order), notice: "Order ##{@order.id} has been updated."
    else
      render 'show'
    end
  end

  def export
    from_date = params[:from_date].blank? ? Date.strptime("01/01/2014", '%m/%d/%Y') : Date.strptime(params[:from_date], '%m/%d/%Y')
    to_date = params[:to_date].blank? ? Date.today : Date.strptime(params[:to_date], '%m/%d/%Y')
    data = CsvGenerator.orders_report(from_date, to_date)
    send_data(data, filename: "orders_report_from_#{from_date}_to_#{to_date}.csv", type: 'text/csv')
  end

  private

  def order_params
    params.require(:order).permit(:status, :tracking_number)
  end
end
