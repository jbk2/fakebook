# == Schema Information
#
# Table name: messages
#
#  id                :bigint           not null, primary key
#  body              :string
#  user_id           :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  conversation_id   :bigint           not null
#  read_by_recipient :boolean          default(FALSE)
#
FactoryBot.define do
  
  factory :message do
    association :user
    association :conversation
    body { "a message" }
  end

end
