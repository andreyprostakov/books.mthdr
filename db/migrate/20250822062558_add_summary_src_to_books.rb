class AddSummarySrcToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :summary_src, :string
  end
end
