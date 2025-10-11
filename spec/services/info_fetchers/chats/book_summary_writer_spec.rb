require 'rails_helper'

RSpec.describe InfoFetchers::Chats::BookSummaryWriter do
  describe '#ask' do
    subject(:result) { writer.ask(book) }

    let(:writer) { described_class.new }
    let(:author) { build_stubbed(:author, fullname: 'F. Scott Fitzgerald') }
    let(:book) do
      build_stubbed(:book, title: 'The Great Gatsby', year_published: 1925, author: author, literary_form: 'novel')
    end
    let(:chat) { instance_double(Ai::Chat) }
    let(:chat_response) { instance_double(RubyLLM::Message, content: response_text) }
    let(:response_text) do
      [
        { summary: 'The Great Gatsby is a novel by F. Scott Fitzgerald.',
          themes: 'Love, Money, Society', genre: 'social_realism', form: 'Novel', src: 'Goodreads' },
        { summary: 'The Great Gatsby is not a novel by F. Scott Fitzgerald.',
          themes: 'Society, Love, Money, Dreams', genre: 'social_realism', form: 'Novel', src: 'Google Books' }
      ].to_json
    end

    before do
      allow(Ai::Chat).to receive(:start).and_return(chat)
      allow(chat).to receive(:with_instructions)
      allow(chat).to receive(:ask)
        .with('Novel "The Great Gatsby" (1925) by F. Scott Fitzgerald')
        .and_return(chat_response)
    end

    it 'returns several summaries of the book' do
      expect(result).to match(
        [
          { summary: 'The Great Gatsby is a novel by F. Scott Fitzgerald.',
            themes: 'Love, Money, Society', genre: 'social_realism', form: 'Novel', src: 'Goodreads' },
          { summary: 'The Great Gatsby is not a novel by F. Scott Fitzgerald.',
            themes: 'Society, Love, Money, Dreams', genre: 'social_realism', form: 'Novel', src: 'Google Books' }
        ]
      )
      expect(writer.errors?).to be false
      expect(writer.last_response).to eq(chat_response)
    end

    context 'when chat response is not a valid JSON' do
      let(:response_text) { 'Invalid JSON' }

      it 'returns an empty array' do
        expect(result).to eq([])
        expect(writer.has_errors?).to be true
        expect(writer.last_response).to eq(chat_response)
      end
    end

    context 'when book has no specified literary form' do
      before { book.literary_form = nil }

      it 'asks chat without literary form' do
        allow(chat).to receive(:ask).and_return(chat_response)
        result
        expect(chat).to have_received(:ask).with('"The Great Gatsby" (1925) by F. Scott Fitzgerald')
      end
    end
  end
end
