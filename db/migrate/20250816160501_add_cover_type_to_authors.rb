class AddCoverTypeToAuthors < ActiveRecord::Migration[8.0]
  def change
    add_column :authors, :cover_type, :string
  end
end
