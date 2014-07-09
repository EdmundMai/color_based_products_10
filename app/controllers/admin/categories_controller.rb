class Admin::CategoriesController < Admin::BaseController
  def create
    @category = Category.where(name: category_params[:name]).first_or_create
    respond_to do |format|
      format.html { redirect_to edit_admin_category_path(@category), notice: "Your category was successfully created."}
    end
  end
  
  def new
    @category = Category.new
  end
  
  def index
    @categories = Category.all.paginate(page: params[:page], per_page: 30)
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      redirect_to edit_admin_category_path(@category), notice: "Your category was successfully updated."
    else
      render 'edit'
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_categories_path, notice: "Your category was successfully deleted."
  end
  
  private
  
    def category_params
      params.require(:category).permit(:name)
    end
  
end