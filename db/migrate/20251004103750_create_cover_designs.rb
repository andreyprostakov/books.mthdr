class CreateCoverDesigns < ActiveRecord::Migration[8.0]
  def change
    create_table :cover_designs do |t|
      t.string :name, null: false
      t.string :title_color, null: false
      t.string :title_font, null: false
      t.string :author_name_color, null: false
      t.string :author_name_font, null: false
      t.string :cover_image, null: false
      t.timestamps
    end
  end
end
