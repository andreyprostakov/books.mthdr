class CreateAiMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_messages do |t|
      t.references :chat, null: false, foreign_key: { to_table: :ai_chats }
      t.references :tool_call, null: true, foreign_key: { to_table: :ai_tool_calls }
      t.string :role
      t.text :content
      t.string :model_id
      t.integer :input_tokens
      t.integer :output_tokens

      t.timestamps
    end
  end
end
