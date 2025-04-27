class RemoveBooksWikiUrl < ActiveRecord::Migration[8.0]
  def change
    remove_column :books, :wiki_url, :string
  end
end
