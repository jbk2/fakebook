# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_likes_on_post_id  (post_id)
#  index_likes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true

  validate :unique_like_per_user_post
  validate :not_own_post

  private
  def unique_like_per_user_post
    if Like.exists?(user_id: user_id, post_id: post_id)
      errors.add(:user_id, "You've already liked this post")
    end
  end

  def not_own_post
    errors.add(:post_id, "You can't like your own post") if user_id == post.user_id
  end

end
