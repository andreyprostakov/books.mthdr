class AddWikiPopularityToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :wiki_popularity, :integer, default: 0
  end
end
