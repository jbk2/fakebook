class AddBodyToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :body, :string
  end
end
