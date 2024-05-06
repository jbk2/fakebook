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
  belongs_to :user
  belongs_to :conversation

  validates :body, presence: true
  validates :conversation_id, presence: true

end
