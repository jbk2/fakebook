module PostsHandler
  extend ActiveSupport::Concern

  def current_user_and_following_posts
    own_posts = current_user.posts
    following_posts = current_user.followed_users.map(&:posts).flatten
    (own_posts + following_posts).sort_by(&:created_at).reverse
  end

end