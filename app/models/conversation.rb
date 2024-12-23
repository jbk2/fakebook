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
class Conversation < ApplicationRecord
  belongs_to :participant_one, class_name: 'User'
  belongs_to :participant_two, class_name: 'User'
  has_many :messages, dependent: :destroy

  validate :participants_must_be_different
  validate :conversation_participant_uniqueness

  scope :between, -> (sender_id, recipient_id) do
    where("(conversations.participant_one_id = ? AND conversations.participant_two_id = ?) OR (conversations.participant_one_id = ? AND conversations.participant_two_id = ?)", sender_id, recipient_id, recipient_id, sender_id)
  end

  scope :active, -> { joins(:messages).where('messages.created_at > ?', 1.hour.ago).distinct }

  def participants
    User.where(id: [participant_one_id, participant_two_id])
  end

  def other_participant(participant)
    participants.where.not(id: participant.id).first
  end

  private
  def participants_must_be_different
    if participant_one_id == participant_two_id
      errors.add(:participant_two_id, "cannot be the same as participant_one_id") 
    end
  end

  def conversation_participant_uniqueness
    existing_conversation = Conversation.between(participant_one_id, participant_two_id).where.not(id: id)
    unless existing_conversation.empty?
      Rails.logger.debug "Can't create new conversation with participant id's; #{participant_one_id} & #{participant_two_id} " +
        "because existing conversation_id#; #{existing_conversation.pluck(:id)} already exists"
      errors.add(:base,
        "a conversation between #{participant_two_id} & #{participant_one_id} already exists; conversation_id# #{existing_conversation.first.id}")
    end
  end

end
