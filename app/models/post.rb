# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  body           :string
#  comments_count :integer          default(0), not null
#  likes_count    :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :photos do |attachable|
    attachable.variant :medium, resize_to_fill: [400, 400], preprocessed: true
  end

  validates :body, presence: true
  validates :body, length: { in: 3..250 }
end
