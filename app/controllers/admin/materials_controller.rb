class Admin::MaterialsController < Admin::BaseController
  def create
    @material = Material.where(name: material_params[:name]).first_or_create
    respond_to do |format|
      format.js
      format.html { redirect_to edit_admin_material_path(@material), notice: "Your material was successfully created."}
    end
  end

  def new
    @material = Material.new
  end

  def index
    @materials = Material.all.paginate(page: params[:page], per_page: 30)
  end

  def edit
    @material = Material.find(params[:id])
  end

  def update
    @material = Material.find(params[:id])
    if @material.update_attributes(material_params)
      redirect_to edit_admin_material_path(@material), notice: "Your material was successfully updated."
    else
      render 'edit'
    end
  end

  def destroy
    @material = Material.find(params[:id])
    @material.destroy
    redirect_to admin_materials_path, notice: "Your material was successfully deleted."
  end

  private

  def material_params
    params.require(:material).permit(:name)
  end
end
