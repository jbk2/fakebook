# == Schema Information
#
# Table name: follows
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :bigint           not null
#  follower_id :bigint           not null
#
# Indexes
#
#  index_follows_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  validates :follower_id, uniqueness: { scope: :followed_id, message: "You are already following this user" }
  validate :cannot_follow_self

  private

  def cannot_follow_self
    errors.add(:follower_id, "cannot be the same as followed_id") if follower_id == followed_id
  end

end
