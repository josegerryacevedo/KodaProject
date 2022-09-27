module ApplicationHelper
  def filter_post
    current_user_friend_lists = Friendship.includes(:user)
                                           .where(user: current_user)
                                           .or(Friendship.includes(:user).where(friend_id: current_user))
    friend_lists = current_user_friend_lists.confirmed
    confirmed_friends_ids = (friend_lists.pluck(:friend_id) + friend_lists.pluck(:user_id)).uniq
    general_posts = Post.general
    friend_posts = Post.where(audience: :friend).where(user: confirmed_friends_ids)
    user_posts = current_user.posts
    general_posts + user_posts + friend_posts
  end
end
