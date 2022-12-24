class Public::FavoritesController < Public::ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @favorite = current_customer.favorites.new(post_id: @post.id)
    @favorite.save
    @post.create_notification_like!(current_customer)
    render 'replace_btn'
  end

  def destroy
    @post = Post.find(params[:post_id])
    @favorite = current_customer.favorites.find_by(post_id: @post.id)
    @favorite.destroy
    render 'replace_btn'
  end

end
