class Public::ApplicationController < ApplicationController


  #ApplicationControllerにネストして、まとめて下記のアクションをかけております。
  before_action :authenticate_customer!

end