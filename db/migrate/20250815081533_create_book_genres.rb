class CreateBookGenres < ActiveRecord::Migration[8.0]
  def change
    create_table :book_genres do |t|
      t.string :name, null: false
      t.references :book, null: false, foreign_key: true
      t.timestamps
    end

    add_index :book_genres, [:book_id, :name], unique: true
  end
end
