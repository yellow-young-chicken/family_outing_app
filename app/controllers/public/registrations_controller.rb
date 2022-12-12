# frozen_string_literal: true

class Public::RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters, only: [:create]
  before_action :ensure_normal_customer, only: [:destroy,:update]
  before_action :configure_update_params, only: [:update]


  def after_sign_up_path_for(resource)
    flash[:notice] = "登録完了しました"
    about_path
  end

  def after_update_path_for(resource)
    flash[:notice] = "変更完了しました"
    about_path
  end


  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end


  # データ操作許可のためのメゾットです。
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:last_name, :first_name, :last_name_kana, :first_name_kana, :account_name, :email, :phone_number, :spot_id])
  end
  # パスワードなどののためのメゾットです。
  def configure_update_params
   devise_parameter_sanitizer.permit(:account_update, keys: [:email,:password])
  end

  # ゲストユーザーを削除できないようにするためのメゾットです。
  # カスタマーコントローラーの際は、reso~~がcurrentcus~~に変更
  def ensure_normal_customer
    if resource.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの更新・削除はできません。'
    end
  end

end
