# == Schema Information
#
# Table name: conversations
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  participant_one_id :bigint           not null
#  participant_two_id :bigint           not null
#
# Indexes
#
#  index_conversations_on_participant_one_id  (participant_one_id)
#  index_conversations_on_participant_two_id  (participant_two_id)
#
# Foreign Keys
#
#  fk_rails_...  (participant_one_id => users.id)
#  fk_rails_...  (participant_two_id => users.id)
#
FactoryBot.define do

  factory :conversation do
    association :participant_one, factory: :user
    association :participant_two, factory: :user
  end

end
