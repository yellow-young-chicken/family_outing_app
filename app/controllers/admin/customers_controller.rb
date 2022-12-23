class Admin::CustomersController < ApplicationController

  before_action :authenticate_admin!


  def new
  end

  def index
    @customers = Customer.page(params[:page]).order(created_at: "DESC")
  end

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts.page(params[:page])
  end

  def edit
    @customer = Customer.find(params[:id])
    @spot_id_pair = Spot.pluck('spot_name, id').to_h
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      flash.now[:notice] = "編集に成功しました!"
      redirect_to customer_path(@customer.id)
    else
      @spot_id_pair = Spot.pluck('spot_name, id').to_h
      render :edit

    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to root_path
  end


private
  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana,:email,:account_name,:profile_image,:spot_id, :phone_number, :introduction, :is_deleted)
  end

end