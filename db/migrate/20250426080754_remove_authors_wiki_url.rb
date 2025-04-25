class RemoveAuthorsWikiUrl < ActiveRecord::Migration[8.0]
  def change
    remove_column :authors, :wiki_url, :string
  end
end
