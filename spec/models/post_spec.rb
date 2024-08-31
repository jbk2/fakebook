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


require 'rails_helper'

RSpec.describe Post, type: :model do

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:owner) }
    it { should have_many_attached(:photos) }
    it { should have_many(:likes) }
    it { should have_many(:comments) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(3).is_at_most(250) }
  end

end
