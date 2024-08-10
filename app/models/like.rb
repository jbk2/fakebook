# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  post_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
