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

  validates :user_id, uniqueness: { scope: :post_id, message: "you've already liked this post"}
  validate :not_own_post

  private
  def not_own_post
    errors.add(:post_id, "you can't like your own post") if user_id == post.user_id
  end

end
