class RemoveCoverTypeFromAuthors < ActiveRecord::Migration[8.0]
  def change
    remove_column :authors, :cover_type, :string
  end
end
