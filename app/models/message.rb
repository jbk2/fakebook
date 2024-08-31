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
class Message < ApplicationRecord
  attr_accessor :skip_broadcast

  belongs_to :user
  belongs_to :conversation, touch: true

  validates :user_id, presence: true
  validates :body, presence: true
  validates :conversation_id, presence: true

  scope :unread_by_recipient, -> { where(read_by_recipient: false) }

  after_create_commit :broadcast_message, unless: -> { skip_broadcast }


  def mark_as_read_by_recipient
    update(read_by_recipient: true)
  end

  private

  def broadcast_message
    if skip_broadcast # so that seeds or console can create messages without broadcasting & notification
      puts "Skipping broadcast for message_id#{id}"
    else
      Rails.logger.debug("Broadcasting message_id#{id}")
      BroadcastMessageJob.perform_later(self, self.user_id, self.conversation_id)
      Rails.logger.debug("Updating message #{id} read notification")
      UpdateMessageNotificationJob.perform_later(self.id)
    end
  end
end
