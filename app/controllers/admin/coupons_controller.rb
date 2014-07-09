class Admin::CouponsController < Admin::BaseController
  
  # before_filter :prevent_cache, only: [:new]
  
  def index
    @coupons = Coupon.all.paginate(page: params[:page], per_page: 30)
  end
  
  def new
    @coupon = Coupon.new
  end
  
  def create
    reformat_date_order!
    @coupon = Coupon.new(coupon_params)
    if @coupon.save
      redirect_to edit_admin_coupon_path(@coupon), notice: "Your coupon was successfully created."
    else
      reformat_date_order!
      render 'new'
    end
  end
  
  def edit
    @coupon = Coupon.find(params[:id])
  end
  
  def update
    reformat_date_order!
    @coupon = Coupon.find(params[:id])
    if @coupon.update_attributes(coupon_params)
      redirect_to edit_admin_coupon_path(@coupon), notice: "Your coupon was successfully updated."
    else
      reformat_date_order!
      render 'edit'
    end
  end
  
  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy
    redirect_to admin_coupons_path, notice: "Your coupon was successfully deleted."
  end
  
  private
    
    def reformat_date_order!
      start_date = params[:coupon][:start_date]
      end_date = params[:coupon][:end_date]
      start_date[0..1], start_date[3..4] = start_date[3..4], start_date[0..1] if start_date.present?
      end_date[0..1], end_date[3..4] = end_date[3..4], end_date[0..1] if end_date.present?
    end
  
    def coupon_params
      params.require(:coupon).permit(:name, 
                                     :code,
                                     :value, 
                                     :minimum_purchase_amount, 
                                     :start_date, 
                                     :end_date, 
                                     :type, 
                                     :site_wide)
    end
  
end