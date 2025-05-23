# == Schema Information
#
# Table name: ai_messages
#
#  id            :integer          not null, primary key
#  content       :text
#  input_tokens  :integer
#  output_tokens :integer
#  role          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  chat_id       :integer          not null
#  model_id      :string
#  tool_call_id  :integer
#
# Indexes
#
#  index_ai_messages_on_chat_id       (chat_id)
#  index_ai_messages_on_tool_call_id  (tool_call_id)
#
# Foreign Keys
#
#  chat_id       (chat_id => ai_chats.id)
#  tool_call_id  (tool_call_id => ai_tool_calls.id)
#
module Ai
  class Message < AiRecord
    acts_as_message chat_class: 'Ai::Chat',
                    tool_call_class: 'Ai::ToolCall'
    belongs_to :chat, class_name: 'Ai::Chat'
  end
end
