require 'rails_helper'

RSpec.describe InfoFetchers::BookInfoFetcher do
  subject(:fetcher) { described_class.new }

  describe '#sync' do
    subject(:call) { fetcher.sync(book) }

    let(:book) { create(:book) }
    let(:ai_talker) { instance_double(AiClients::BookInfoFetcher) }
    let(:info) do
      {
        'title' => 'Crime and Punishment',
        'original_title' => 'П+Н',
        'publishing_year' => 1000,
        'goodreads_url' => 'https://www.goodreads.com/book/show/2452383.The_Chimes',
        'wiki_url' => 'https://en.wikipedia.org/wiki/Crime_and_Punishment',
        'genre' => 'Psychological Fiction, Crime Fiction, Philosophical Fiction',
        'themes' => 'Morality, Guilt, Redemption',
        'series' => 'The Brothers Karamazov',
        'summary' => 'A psychological novel that explores the moral dilemmas of a young man who...'
      }
    end

    before do
      allow(AiClients::BookInfoFetcher).to receive(:new).and_return(ai_talker)
      allow(ai_talker).to receive(:ask_book_info).with(book.title, book.author).and_return(info)
      allow(Rails.logger).to receive(:info)
    end

    it 'fetches book info and updates book' do # rubocop:disable RSpec/MultipleExpectations
      call

      expect(book.title).to eq(info['title'])
      expect(book.original_title).to eq(info['original_title'])
      expect(book.year_published).to eq(info['publishing_year'])
      expect(book.goodreads_url).to eq(info['goodreads_url'])
      expect(book.wiki_url).to eq(info['wiki_url'])
      expect(book.tags).to match_array(7.times.collect { instance_of(Tag) })
      expect(book.summary).to eq(info['summary'])
    end

    it 'logs book update' do
      call

      expect(Rails.logger).to have_received(:info).with("Book ID=#{book.id} updated")
    end

    it 'returns nil' do
      expect(call).to be_nil
    end
  end
end
