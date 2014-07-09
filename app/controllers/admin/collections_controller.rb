class Admin::CollectionsController < Admin::BaseController
  
  def new
    @collection = Collection.new
  end
  
  def index
    @collections = Collection.all.paginate(page: params[:page], per_page: 30)
  end
  
  def manage_products
    @collection = Collection.find(params[:id])
  end
  
  def create
    @collection = Collection.new(collection_params)
    if @collection.save
      redirect_to edit_admin_collection_path(@collection), notice: "Your collection was successfully created."
    else
      render 'new'
    end
  end
  
  def edit
    @collection = Collection.find(params[:id])
    @search = Product.search(params[:q])
    @products = @search.result.order('name ASC').paginate(:page => params[:page], :per_page => 10)
  end
  
  def update
    @collection = Collection.find(params[:id])
    if @collection.update_attributes(collection_params)
      redirect_to edit_admin_collection_path(@collection), notice: "Your collection was successfully updated."
    else
      render 'edit'
    end
  end
  
  def add_products
    return unless params[:product_ids].present?
    @collection = Collection.find(params[:id])
    params[:product_ids].each do |product_id|
      product = Product.find(product_id)
      @collection.products << product unless @collection.products.include?(product)
    end
    respond_to do |format|
      format.js
    end
  end
  
  def remove_products
    return unless params[:product_ids].present?
    @collection = Collection.find(params[:id])
    params[:product_ids].each do |product_id|
      association = CollectionsProduct.find_by(product_id: product_id, collection_id: @collection.id)
      association.destroy
    end
    respond_to do |format|
      format.js
    end
  end
  
  def search_products
    @collection = Collection.find(params[:id])
    @products = Product.where("name LIKE ?", "%#{params[:search_term]}%")
    respond_to do |format|
      format.js
    end
  end
  
  def reset_search
    @collection = Collection.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @collection = Collection.find(params[:id])
    @collection.destroy
    redirect_to admin_collections_path, notice: "Your collection was successfully deleted."
  end
  
  private
  
    def collection_params
      params.require(:collection).permit(:name, :short_description, :long_description, :active)
    end
  
end