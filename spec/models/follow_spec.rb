# == Schema Information
#
# Table name: follows
#
#  id          :bigint           not null, primary key
#  follower_id :bigint           not null
#  followed_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null


require 'rails_helper'

RSpec.describe Follow, type: :model do
  
  describe 'associations' do
    it { should belong_to(:follower) }
    it { should belong_to(:followed) }
  end

  describe 'validations' do
    subject(:follow) { FactoryBot.create(:follow) }
    # before(:each) do
      # puts "Follow is here: #{follow.inspect}"
    # end

    it { should validate_presence_of(:follower_id) }
    it { should validate_presence_of(:followed_id) }
    it { should validate_uniqueness_of(:follower_id).scoped_to(:followed_id).with_message("You are already following this user") }

    it 'should not allow a user to follow themselves' do
      follow.follower_id = follow.followed_id
      expect(follow).to_not be_valid
    end
  end

end