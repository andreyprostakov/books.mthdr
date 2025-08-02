class AddWikiUrlBackToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :wiki_url, :string
  end
end
