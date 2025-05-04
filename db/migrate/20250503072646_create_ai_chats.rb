class CreateAiChats < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_chats do |t|
      t.string :model_id

      t.timestamps
    end
  end
end
