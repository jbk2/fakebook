class AddReadByRecipientToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :read_by_recipient, :boolean, default: false
  end
end
