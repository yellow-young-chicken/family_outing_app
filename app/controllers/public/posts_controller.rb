class Public::PostsController < ApplicationController
  def new
    @post = Post.new

  end

  def create

    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    @post.save
    redirect_to root_path
  end

  def index
  end

  def show
  end

  def edit
  end

  private

  def post_params
    params.require(:post).permit(:title, :post_content, :images, :latitude, :longitude)
  end

end
