# == Schema Information
#
# Table name: messages
#
#  id                :bigint           not null, primary key
#  body              :string
#  read_by_recipient :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  conversation_id   :bigint           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_messages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (conversation_id => conversations.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  
  factory :message do
    association :user
    association :conversation
    body { "a message" }
  end

end
