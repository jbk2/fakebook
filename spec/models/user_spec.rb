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
    @user = User.new

  end

  describe 'associations' do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:likes) }
  end


end