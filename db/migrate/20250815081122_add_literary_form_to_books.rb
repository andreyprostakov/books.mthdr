class AddLiteraryFormToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :literary_form, :string, null: false, default: 'novel'
  end
end
