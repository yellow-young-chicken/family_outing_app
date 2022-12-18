class Public::PostsController < ApplicationController
  def new
    @post = Post.new
    #@spot_id_pairでハッシュを使い、spot_nameをidに変換しております。
    @spot_id_pair = Spot.pluck('spot_name, id').to_h

  end

  def create
    @post = current_customer.posts.build(post_params)
    if @post.save
      flash[:notice] = "投稿に成功しました！"
      redirect_to posts_path
    else
      # renderの際のnilエラー解消のため、＠spot_id_pairを入れております。
      @spot_id_pair = Spot.pluck('spot_name, id').to_h
      render :new
    end
  end

  def index

    @tags = Post.tag_counts_on(:tags).order('count DESC') 
    if @tag = params[:tag_name]   # タグ検索用
      @posts = Post.tagged_with(@tag).page(params[:page]).order("created_at DESC")
    else
      @posts = Post.page(params[:page]).order("created_at DESC")
    end
  end

  def favorites_ranking
    @tags = Post.tag_counts_on(:tags).order('count DESC')
    @posts = Post.includes(:liked_customers).sort {|a,b| b.liked_customers.size <=> a.liked_customers.size}

  end

  def follow_posts
    @tags = Post.tag_counts_on(:tags).order('count DESC')
    @posts = Post.where(customer_id: [current_customer.following_ids])
    # @posts = Post.where(customer_id: [current_customer.id, *current_customer.following_ids])
  end

  def my_posts
    @tags = Post.tag_counts_on(:tags).order('count DESC')
    @posts = Post.where(customer_id: current_customer.id)
  end



  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
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
      redirect_to post_path(@post.id)
    else
      @spot_id_pair = Spot.pluck('spot_name, id').to_h
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "削除が完了しました"
    redirect_to posts_path
  end


  private

  def post_params
    params.require(:post).permit(:title, :post_content, :latitude, :longitude, :rate, :tag_list, :spot_id, images: [])
  end

end
