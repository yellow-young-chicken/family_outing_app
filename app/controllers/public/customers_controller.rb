class Public::CustomersController < ApplicationController

  before_action :is_matching_login_customer, only: [:edit, :update]


  def new
  end

  def index
    @customers = Customer.page(params[:page])
  end

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts.page(params[:page])

  end

  def edit
    @customer = Customer.find(params[:id])
    #@spot_id_pairでハッシュを使い、spot_nameをidに変換しております。
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


  private

  def customer_params
    params.require(:customer).permit(:account_name,:profile_image,:spot_id, :email, :phone_number, :introduction)
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
