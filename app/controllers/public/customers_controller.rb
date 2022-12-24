class Public::CustomersController < Public::ApplicationController


  before_action :is_matching_login_customer, only: [:edit, :update, :destroy]
  before_action :ensure_normal_customer, only: [:destroy,:update]


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
    #@spot_id_pairでハッシュを使い、spot_nameをidに変換しております。
    @spot_id_pair = Spot.pluck('spot_name, id').to_h
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      flash[:notice] = "編集に成功しました!"
      redirect_to customer_path(@customer.id)
    else
      @spot_id_pair = Spot.pluck('spot_name, id').to_h
      render :edit
    end
  end

    def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    flash[:notice] = "削除が完了しました"
    redirect_to root_path
    end



  def favorites
    @customer = Customer.find(params[:id])
    favorites = Favourite.where(customer_id: @customer.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
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

    # ゲストユーザーを削除できないようにするためのメゾットです。
  # カスタマーコントローラーの際は、reso~~がcurrentcus~~に変更
  def ensure_normal_customer
    if current_customer.email == 'guest@example.com'
      flash[:notice] = 'ゲストユーザーの更新・削除はできません。'
      redirect_to root_path
    end
  end



end
