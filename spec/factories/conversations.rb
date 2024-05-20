# == Schema Information
#
# Table name: conversations
#
#  id                 :bigint           not null, primary key
#  participant_one_id :bigint           not null
#  participant_two_id :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do

  factory :conversation do
    association :participant_one, factory: :user
    association :participant_two, factory: :user
  end

end
