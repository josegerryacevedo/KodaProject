class Users::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @current_user_friend_lists = Friendship.includes(:user)
                                           .where(user: current_user)
                                           .or(Friendship.includes(:user).where(friend_id: current_user))
    @friend_lists = @current_user_friend_lists.confirmed
    @friend_ids = (@current_user_friend_lists.pluck(:friend_id) + @current_user_friend_lists.pluck(:user_id)).uniq
    @users = User.where.not(id: current_user.id).where.not(id: @friend_ids)
    @confirmed_friends_ids = (@friend_lists.pluck(:friend_id) + @friend_lists.pluck(:user_id)).uniq
    @general_posts = Post.general
    @friend_posts = Post.where(audience: :friend).where(user: @confirmed_friends_ids)
    @user_posts = current_user.posts
    @post_to_display = Post.where(id: @general_posts.pluck(:id) + @user_posts.pluck(:id) + @friend_posts.pluck(:id))
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

  def edit
    authorize @post, :edit?, policy_class: PostPolicy
  end

  def update
    authorize @post, :update?, policy_class: PostPolicy
    if @post.update(post_params)
      redirect_to users_posts_path, notice: 'Successfully Updated!'
    else
      render :edit
    end
  end

  def destroy
    authorize @post, :destroy?, policy_class: PostPolicy
    if @post.destroy
      flash[:notice] = "Successfully Deleted!"
    else
      flash[:alert] = "Failed to delete!"
    end
    redirect_to users_posts_path
  end

  private

  def post_params
    params.require(:post).permit(:content, :title, :image, :audience)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end