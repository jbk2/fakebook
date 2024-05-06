class AddForeignKeyToMessages < ActiveRecord::Migration[7.1]
  def change
    change_column :messages, :conversation_id, :bigint
    add_foreign_key :messages, :conversations, column: :conversation_id
  end
end
