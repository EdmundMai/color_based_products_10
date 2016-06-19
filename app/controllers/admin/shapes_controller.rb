class Admin::ShapesController < Admin::BaseController
  def create
    @shape = Shape.where(name: shape_params[:name]).first_or_create
    respond_to do |format|
      format.js
      format.html { redirect_to edit_admin_shape_path(@shape), notice: "Your shape was successfully created."}
    end
  end

  def new
    @shape = Shape.new
  end

  def index
    @shapes = Shape.all.paginate(page: params[:page], per_page: 30)
  end

  def edit
    @shape = Shape.find(params[:id])
  end

  def update
    @shape = Shape.find(params[:id])
    if @shape.update_attributes(shape_params)
      redirect_to edit_admin_shape_path(@shape), notice: "Your shape was successfully updated."
    else
      render 'edit'
    end
  end

  def destroy
    @shape = Shape.find(params[:id])
    @shape.destroy
    redirect_to admin_shapes_path, notice: "Your shape was successfully deleted."
  end

  private

  def shape_params
    params.require(:shape).permit(:name)
  end

end
