class AddOriginalFullnameToAuthors < ActiveRecord::Migration[8.0]
  def change
    add_column :authors, :original_fullname, :string
  end
end
