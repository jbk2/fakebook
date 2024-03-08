module PostsHandler
  extend ActiveSupport::Concern

  def current_user_and_following_user_posts
    Post.includes(user: :profile_photo_attachment)
      .with_attached_photos
      .where(user: [current_user] + current_user.followed_users)
      .order(created_at: :desc)
  end
end