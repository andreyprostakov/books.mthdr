class RemoveAwsCoversFromBooks < ActiveRecord::Migration[8.0]
  def change
    remove_column :books, :aws_covers, :json
  end
end
