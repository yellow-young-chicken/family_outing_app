class Admin::PostsController < Admin::ApplicationController


  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def index
      @tags = Post.tag_counts_on(:tags).order('count DESC')
    if @tag = params[:tag_name]   # タグ検索用
      @posts = Post.tagged_with(@tag).page(params[:page]).order("created_at DESC")
    else
      @posts = Post.page(params[:page]).order("created_at DESC")
    end
  end

  def edit
    @post = Post.find(params[:id])
    #@spot_id_pairでハッシュを使い、spot_nameをidに変換しております。
    @spot_id_pair = Spot.pluck('spot_name, id').to_h
  end


  def update
    @post = Post.find(params[:id])
    if  @post.update(post_params)
      flash[:notice] = "編集に成功しました！"
      redirect_to admin_post_path(@post.id)
    else
      @spot_id_pair = Spot.pluck('spot_name, id').to_h
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "削除が完了しました"
    redirect_to admin_posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :post_content, :latitude, :longitude, :rate, :tag_list, :spot_id, images: [])
  end


end
