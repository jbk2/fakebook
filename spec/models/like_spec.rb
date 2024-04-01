# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  post_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null

require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:user_1) { FactoryBot.create(:user) }
  let!(:user_2) { FactoryBot.create(:user) }
  let!(:user_1_post) { FactoryBot.create(:post, user: user_1) }
  let!(:user_2_post) { FactoryBot.create(:post, user: user_2) }
  let!(:valid_like_1) { FactoryBot.create(:like, user: user_1, post: user_2_post) }
  let!(:valid_like_2) { FactoryBot.create(:like, user: user_2, post: user_1_post) }
  let(:invalid_like_1) { FactoryBot.build(:like, user: user_1, post: user_1_post) }
  let(:invalid_like_2) { FactoryBot.build(:like, user: user_2, post: user_2_post) }
  
  describe 'associations' do
    it "should belong to a user" do
      expect(valid_like_1.user).to be_instance_of(User)
      expect(valid_like_2.user).to be_instance_of(User)
    end

    it "should belong to a post"  do
      expect(valid_like_1.post).to be_instance_of(Post)
      expect(valid_like_2.post).to be_instance_of(Post)
    end
  end

  describe 'validations' do
    it "should not allow a user to like their own post" do
      expect(invalid_like_1).to_not be_valid
      expect(invalid_like_1.errors[:post_id]).to include("you can't like your own post")
      expect(invalid_like_2).to_not be_valid
      expect(invalid_like_2.errors[:post_id]).to include("you can't like your own post")
    end

    it "should validate that a user can't like the same post more than once" do
      dup_like = FactoryBot.build(:like, user: user_1, post: user_2_post)
      expect(dup_like).to_not be_valid
      expect(dup_like.errors[:user_id]).to include("you've already liked this post")
    end
  end
end
