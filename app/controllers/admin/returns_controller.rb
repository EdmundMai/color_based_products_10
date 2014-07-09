class Admin::ReturnsController < Admin::BaseController
  
  def index
    @search_terms = params[:q]
    @search = Return.search(@search_terms)
    @returns = @search.result.paginate(page: params[:page], per_page: 30)
    
  end
  
  def show
    @return = Return.find(params[:id])
  end
  
  def update
    @return = Return.find(params[:id])
    if @return.update_attributes(return_params)
      redirect_to admin_return_path(@return), notice: "Your return was successfully updated."
    else
      render 'show'
    end
  end
  
  private
  
  def return_params
    params.require(:return).permit(:status, :admin_comment, :amount)
  end
  
end