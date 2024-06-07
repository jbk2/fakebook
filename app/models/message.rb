# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  body            :string
#  user_id         :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :bigint           not null
#
class Message < ApplicationRecord
  attr_accessor :skip_broadcast

  belongs_to :user
  belongs_to :conversation

  validates :user_id, presence: true
  validates :body, presence: true
  validates :conversation_id, presence: true

  after_create_commit :broadcast_message, unless: -> { skip_broadcast }

  private

  def broadcast_message
    if skip_broadcast
      puts "Skipping broadcast for message_id#{id}"
    else
      puts "Broadcasting message_id#{id}"
      BroadcastMessageJob.perform_later(self, self.user_id, self.conversation_id)
    end
  end
end
