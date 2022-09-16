class Users::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to users_posts_path, notice: 'Successfully Post!'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to users_posts_path, notice: 'Successfully Updated!'
    else
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = "Successfully Deleted!"
    else
      flash[:alert] = "Failed to delete!"
    end
    redirect_to users_posts_path
  end

  private

  def post_params
    params.require(:post).permit(:content, :title, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end