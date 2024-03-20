class CreatePhotoProcessStates < ActiveRecord::Migration[7.1]
  def change
    create_table :photo_process_states do |t|
      t.references :attachment, null: false, foreign_key: { to_table: :active_storage_attachments }
      t.boolean :processed, default: false, null: false
      t.timestamps
    end
  end
end
