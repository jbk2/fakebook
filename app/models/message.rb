# == Schema Information
#
# Table name: messages
#
#  id           :bigint           not null, primary key
#  body         :string
#  user_id      :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :integer
#
class Message < ApplicationRecord
  belongs_to :user
end
