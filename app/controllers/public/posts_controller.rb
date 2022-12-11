class Public::PostsController < ApplicationController
  def new
    @post = Post.new
    #@spot_id_pairでハッシュを使い、spot_nameをidに変換しております。
    @spot_id_pair = Spot.pluck('spot_name, id').to_h

  end

  def create
    @post = current_customer.posts.build(post_params)
    if @post.save
      redirect_to root_path
    else
      # renderの際のnilエラー解消のため、＠spot_id_pairを入れております。
      @spot_id_pair = Spot.pluck('spot_name, id').to_h
      render :new
    end
  end

  def index
    @posts = Post.page(params[:page])

  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def edit
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end


  private

  def post_params
    params.require(:post).permit(:title, :post_content, :latitude, :longitude, :spot_id, images: [])
  end

end
