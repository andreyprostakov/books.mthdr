class CreateGenres < ActiveRecord::Migration[8.0]
  def change
    create_table :genres do |t|
      t.string :name, null: false, index: { unique: true }
      t.references :cover_design, null: true, foreign_key: true
      t.timestamps
    end
  end
end
