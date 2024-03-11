# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :string
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :owner, class_name: "User", foreign_key: "user_id"

  has_many_attached :photos do |attachable|
    attachable.variant :medium, resize_to_fill: [400, 400]
    attachable.variant :large, resize_to_fill: [1000, 1000]
  end
end
