# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#

require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    @user = User.new(email: 'user_1@test.com', password: 'Password12!', username: 'user_1')
  end

  describe 'associations' do
    it { should have_many(:posts) }
    it { should have_many(:following) }
    it { should have_many(:followers) }
    it { should have_many(:likes) }
    it { should have_many(:comments) }
    it { should have_one_attached(:profile_photo) }
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:username).is_at_least(3).is_at_most(20) }
  end


end