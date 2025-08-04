require 'rails_helper'

RSpec.describe InfoFetchers::Chats::BooksExpert do
  subject(:fetcher) { described_class.new }

  describe '#ask_book_info' do
    subject(:call) { fetcher.ask_book_info(book_title, year, author) }

    let(:book_title) { 'Crime and Punishment' }
    let(:year) { 1866 }
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
      allow(mock_chat).to receive(:ask).with("\"#{book_title}\" (#{year}) by #{author.fullname}")
                                       .and_return(mock_response)
    end

    it 'returns parsed JSON response' do
      expect(call).to eq(expected_response)
    end

    it 'sets up chat with correct instructions' do
      call
      expect(mock_chat).to have_received(:with_instructions)
    end
  end
end
