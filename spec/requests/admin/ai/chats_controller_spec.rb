require 'rails_helper'

RSpec.describe Admin::Ai::ChatsController, type: :request do
  describe 'GET /admin/ai/chats' do
    let(:send_request) { get admin_ai_chats_path, headers: authorization_header }
    let(:chats) { create_list(:ai_chat, 3) }

    before { chats }

    it 'renders chats' do
      send_request
      expect(response).to be_successful
      expect(response).to render_template 'admin/ai/chats/index'
      expect(assigns(:chats)).to match_array(chats)
    end
  end

  describe 'GET /admin/ai/chats/:id' do
    let(:send_request) { get admin_ai_chat_path(chat), headers: authorization_header }
    let(:chat) { create(:ai_chat, messages: messages) }
    let(:messages) { build_list(:ai_message, 3) }

    it 'renders a successful response' do
      send_request
      expect(response).to be_successful
      expect(response).to render_template 'admin/ai/chats/show'
      expect(assigns(:chat)).to eq(chat)
      expect(assigns(:messages)).to match_array(messages)
    end
  end
end
