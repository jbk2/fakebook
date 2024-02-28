class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.bigint :follower_id, null: false, foreign_key: { to_table: :users }
      t.bigint :followed_id, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :follows, [:follower_id, :followed_id], unique: true
  end
end
