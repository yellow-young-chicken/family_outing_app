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
    @posts = Post.all
    
  end

  def show
    @post = Post.find(params[:id])
    
  end

  def edit
  end
  
  def destroy
    @post =Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :post_content, :images, :latitude, :longitude)
  end

end
