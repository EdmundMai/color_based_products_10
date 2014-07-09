class Admin::ColorsController < Admin::BaseController
  def create
    @color = Color.where(name: color_params[:name]).first_or_initialize
    @color.image = color_params[:image] unless color_params[:image].blank?
    
    @index = params[:index]
    
    @color.save
    respond_to do |format|
      format.js
      format.html { redirect_to edit_admin_color_path(@color), notice: "Your color was successfully created."}
    end
  end
  
  def update
    @color = Color.find(params[:id])
    if @color.update_attributes(color_params)
      redirect_to edit_admin_color_path(@color), notice: "Your color was successfully updated."
    else
      render 'edit'
    end
  end
  
  def destroy
    @color = Color.find(params[:id])
    @color.destroy
    redirect_to admin_colors_path, notice: "Your color was successfully deleted."
  end
  
  def delete_image
    @color = Color.find(params[:id])
    @color.remove_image!
    @color.save
    respond_to do |format|
      format.js
    end
  end
  
  def new
    @color = Color.new
  end
  
  def index
    @colors = Color.all.paginate(page: params[:page], per_page: 30)
  end
  
  def edit
    @color = Color.find(params[:id])
  end
  
  private
  
    def color_params
      params.require(:color).permit(:name, :image)
    end
  
end