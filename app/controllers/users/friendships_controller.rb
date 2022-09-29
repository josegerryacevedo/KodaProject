class Users::FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friendship, except: [:index, :create]

  def index
    @friendships = Friendship.includes(:user).where(user: current_user)
    @inverse_friends = Friendship.includes(:user).where(friend_id: current_user)
    @current_user_friend_lists = @friendships.or(@inverse_friends)
    @friend_lists = @current_user_friend_lists.confirmed
  end

  def create
    is_friendship_existing = current_user.friendships.where(friend_id: params[:friend_id]).blank? && current_user.inverse_friendships.where(user_id: params[:friend_id]).blank? && current_user.id != params[:friend_id].to_i
    if is_friendship_existing
      @friendship = current_user.friendships.new(friend_id: params[:friend_id])
      @friendship.save
      flash[:notice] = 'Request Sent!'
    else
      flash[:alert] = 'This user is already existed!'
    end
    redirect_to users_posts_path
  end

  def confirm
    authorize @friendship, :confirm?, policy_class: FriendshipPolicy
    if @friendship.may_confirm? && @friendship.confirm!
      flash[:notice] = "Successfully Friend!"
    else
      flash[:alert] = @friendship.errors.full_messages.join(', ')
    end
    redirect_to users_posts_path
  end

  def cancel
    authorize @friendship, :cancel?, policy_class: FriendshipPolicy
    if @friendship.may_cancel? && @friendship.cancel!
      flash[:notice] = "Successfully Cancelled!"
    else
      flash[:alert] = @friendship.errors.full_messages.join(', ')
    end
    redirect_to users_posts_path
  end

  def decline
    authorize @friendship, :decline?, policy_class: FriendshipPolicy
    if @friendship.may_decline? && @friendship.decline!
      flash[:notice] = "Successfully Declined!"
    else
      flash[:alert] = @friendship.errors.full_messages.join(', ')
    end
    redirect_to users_posts_path
  end

  def unfriend
    authorize @friendship, :unfriend?, policy_class: FriendshipPolicy
    if @friendship.may_unfriend? && @friendship.unfriend!
      flash[:notice] = "Successfully Unfriend!"
    else
      flash[:alert] = @friendship.errors.full_messages.join(', ')
    end
    redirect_to users_posts_path
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:friendship_id])
  end
end