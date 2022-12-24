class Admin::ApplicationController < ApplicationController


#ApplicationControllerにネストして、まとめて下記のアクションをかけております。
  before_action :authenticate_admin!

end
