# == Schema Information
#
# Table name: messages
#
#  id                   :bigint           not null, primary key
#  body                 :string
#  user_id              :bigint           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  message_recipient_id :integer
#
require 'rails_helper'

RSpec.describe Message, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
