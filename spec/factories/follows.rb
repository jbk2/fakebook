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
FactoryBot.define do
  factory :follow do
    follower { create(:user)}
    followed { create(:user)}
  end
end
