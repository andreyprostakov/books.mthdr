class AddMissingUniqueIndices < ActiveRecord::Migration[6.1]
  def change
    add_index :authors, :fullname, unique: true
    add_index :books, %i[title author_id], unique: true
  end
end
