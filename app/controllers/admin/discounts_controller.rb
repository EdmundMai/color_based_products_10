class Admin::DiscountsController < Admin::BaseController
  
  def index
  end
  
  def apply
    products_colors_ids = params[:chosen_products_for_discounts][:ids].reject(&:blank?)
    collections_ids = params[:chosen_collections_for_discounts][:ids].reject(&:blank?)
    
    if params[:apply]
      discount = Discount.new(percentage: params[:percentage].to_f)
      discount.apply_to_products!(products_colors_ids)
      discount.apply_to_collections!(collections_ids)
    elsif params[:remove]
      Discount.remove_from_products!(products_colors_ids)
      Discount.remove_from_collections!(collections_ids)
    end
    
    redirect_to admin_discounts_path, notice: "Your products have been discounted."
  end
  
end