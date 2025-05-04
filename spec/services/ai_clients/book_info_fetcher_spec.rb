require 'rails_helper'

RSpec.describe AiClients::BookInfoFetcher do
  subject(:fetcher) { described_class.new }

  describe '#ask_book_info' do
    let(:book_title) { 'Crime and Punishment' }
    let(:author) { build_stubbed(:author, fullname: 'Fyodor Dostoevsky') }
    let(:mock_chat) { instance_double(Ai::Chat) }
    let(:mock_response) { instance_double(RubyLLM::Message, content: expected_response.to_json) }
    let(:expected_response) do
      {
        title: 'Crime and Punishment',
        original_title: 'П+Н',
        publishing_year: 1000,
        goodreads_url: 'https://www.goodreads.com/book/show/2452383.The_Chimes',
        wiki_url: 'https://en.wikipedia.org/wiki/Crime_and_Punishment',
        genre: 'Psychological Fiction, Crime Fiction, Philosophical Fiction',
        themes: 'Morality, Guilt, Redemption',
        series: 'The Brothers Karamazov',
        summary: 'A psychological novel that explores the moral dilemmas of a young man who...'
      }.deep_stringify_keys
    end

    before do
      allow(Ai::Chat).to receive(:start).and_return(mock_chat)
      allow(mock_chat).to receive(:with_instructions).and_return(mock_chat)
      allow(mock_chat).to receive(:ask).with("\"#{book_title}\" by #{author.fullname}").and_return(mock_response)
    end

    it 'returns parsed JSON response' do
      result = fetcher.ask_book_info(book_title, author)
      expect(result).to eq(expected_response)
    end

    it 'sets up chat with correct instructions' do
      fetcher.ask_book_info(book_title, author)
      expect(mock_chat).to have_received(:with_instructions)
    end

    it 'asks chat with book title and author name' do
      fetcher.ask_book_info(book_title, author)
      expect(mock_chat).to have_received(:ask).with("\"#{book_title}\" by #{author.fullname}")
    end
  end
end
