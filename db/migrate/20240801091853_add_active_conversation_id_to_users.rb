class AddActiveConversationIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :active_conversation_id, :integer, default: nil
  end
end
