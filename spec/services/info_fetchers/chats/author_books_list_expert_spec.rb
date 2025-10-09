require 'rails_helper'

RSpec.describe InfoFetchers::Chats::AuthorBooksListExpert do
  subject(:expert) { described_class.new }

  describe '#ask_books_list' do
    subject(:result) { expert.ask_books_list(author) }

    let(:author) { create(:author, fullname: 'David Copperfield') }
    let(:chat) { instance_double(Ai::Chat) }
    let(:chat_response) { instance_double(RubyLLM::Message, content: chat_output) }
    let(:chat_output) { '{"notes": "Notes", "works": [["David Copperfield", null, "1850", "novel", "WIKI_URL"]]}' }

    before do
      allow(Ai::Chat).to receive(:start).and_return(chat)
      allow(chat).to receive(:with_instructions)
      allow(chat).to receive(:ask).with('Author: David Copperfield').and_return(chat_response)
    end

    it 'returns raw JSON response' do
      expect(result).to eq(chat_output)
    end

    it 'sets up chat with instructions' do
      result
      expect(chat).to have_received(:with_instructions).with(described_class::INSTRUCTIONS)
    end

    context 'when chat responds with bad JSON' do
      let(:chat_output) { 'invalid JSON' }

      it 'returns raw JSON response' do
        expect(result).to eq(chat_output)
      end
    end
  end
end
