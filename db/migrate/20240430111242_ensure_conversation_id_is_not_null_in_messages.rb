class EnsureConversationIdIsNotNullInMessages < ActiveRecord::Migration[7.1]
  def change
    change_column_null :messages, :conversation_id, false
  end
end
