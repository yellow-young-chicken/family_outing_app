class Admin::FavoritesController < ApplicationController
  
  before_action :authenticate_admin!
  
    def destroy
    @post = Post.find(params[:post_id])
    @favorite = current_customer.favorites.find_by(post_id: @post.id)
    @favorite.destroy
    render 'replace_btn'
  end
  
end
