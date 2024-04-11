class AddMessageRecipientIdToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :message_recipient_id, :integer
  end
end
