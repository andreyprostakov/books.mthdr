class CreateWikiPageStats < ActiveRecord::Migration[8.0]
  def change
    create_table :wiki_page_stats do |t|
      t.references :entity, polymorphic: true, null: false
      t.string :locale, null: false
      t.string :name, null: false
      t.integer :views
      t.integer :views_last_month
      t.datetime :views_synced_at

      t.timestamps
    end
  end
end
