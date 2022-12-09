class Public::CustomersController < ApplicationController
  def new
  end

  def index
  end

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts

  end

  def edit
    @customer = Customer.find(params[:id])
  end
  
  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    redirect_to customer_path(@customer.id)
  end
  
  
  private
  
  def customer_params
    
    params.require(:customer).permit(:account_name,:profile_image)
  end



end
