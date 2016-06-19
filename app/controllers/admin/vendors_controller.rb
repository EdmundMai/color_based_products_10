class Admin::VendorsController < Admin::BaseController
  def create
    @vendor = Vendor.where(name: vendor_params[:name]).first_or_create
    respond_to do |format|
      format.js
      format.html { redirect_to edit_admin_vendor_path(@vendor), notice: "Your vendor was successfully created."}
    end
  end

  def new
    @vendor = Vendor.new
  end

  def index
    @vendors = Vendor.all.paginate(page: params[:page], per_page: 30)
  end

  def edit
    @vendor = Vendor.find(params[:id])
  end

  def update
    @vendor = Vendor.find(params[:id])
    if @vendor.update_attributes(vendor_params)
      redirect_to edit_admin_vendor_path(@vendor), notice: "Your vendor was successfully updated."
    else
      render 'edit'
    end
  end

  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy
    redirect_to admin_vendors_path, notice: "Your vendor was successfully deleted."
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name)
  end

end
