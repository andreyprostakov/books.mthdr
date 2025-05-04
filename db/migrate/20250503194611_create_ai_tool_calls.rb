class CreateAiToolCalls < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_tool_calls do |t|
      t.references :message, null: false, foreign_key: { to_table: :ai_messages }
      t.string :tool_call_id, index: true
      t.string :name
      t.text :arguments
      t.timestamps
    end
  end
end
