# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  post_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  body       :string
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true
  alias_method :owner, :user

  validates :body, presence: true
  validates :body, length: { in: 3..250 }
end
