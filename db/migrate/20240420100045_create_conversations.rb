class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.references :participant_one, null: false, foreign_key: { to_table: :users }
      t.references :participant_two, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
