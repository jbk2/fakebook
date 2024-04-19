class ChangeMessageReceipientIdToRecipientIdOnMessages < ActiveRecord::Migration[7.1]
  def change
    rename_column :messages, :message_recipient_id, :recipient_id
  end
end
