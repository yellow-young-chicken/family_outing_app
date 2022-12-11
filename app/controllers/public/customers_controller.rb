class Public::CustomersController < ApplicationController
  
  before_action :is_matching_login_customer, only: [:edit, :update]
  
  
  def new
  end

  def index
  end

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts.page(params[:page])

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

  # ログインしているユーザー本人かどうか確認するためのメゾットです。

  def  is_matching_login_customer

    customer_id = params[:id].to_i
    login_customer_id = current_customer.id
    if(customer_id != login_customer_id)
      redirect_to posts_path
    end
  end



end
