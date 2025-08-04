require 'rails_helper'

RSpec.describe InfoFetchers::Chats::BookUpdater do
  subject(:updater) { described_class.new }

  describe '#prepare_updates' do
    subject(:call) { updater.prepare_updates(book) }

    let(:book) { create(:book) }
    let(:ai_talker) { instance_double(InfoFetchers::Chats::BooksExpert) }
    let(:info) do
      {
        'title' => 'Crime and Punishment',
        'original_title' => 'П+Н',
        'publishing_year' => 1000,
        'genre' => 'Psychological Fiction, Crime Fiction, Philosophical Fiction',
        'themes' => 'Morality, Guilt, Redemption',
        'series' => 'The Brothers Karamazov, Crime Fiction',
        'summary' => 'A psychological novel that explores the moral dilemmas of a young man who...'
      }
    end

    before do
      allow(InfoFetchers::Chats::BooksExpert).to receive(:new).and_return(ai_talker)
      allow(ai_talker).to receive(:ask_book_info).with(book.title, book.year_published, book.author).and_return(info)
    end

    it 'fetches book info and updates book' do # rubocop:disable RSpec/MultipleExpectations
      call

      expect(book.title).to eq(info['title'])
      expect(book.original_title).to eq(info['original_title'])
      expect(book.year_published).to eq(info['publishing_year'])
      expect(book.tag_connections.size).to eq(7)
      expect(book.summary).to eq(info['summary'])
    end

    it 'returns the book ready to be saved' do
      expect(call).to eq(book)
      expect(call.changes).to be_present
    end

    it 'creates missing tags' do
      expect { call }.to change(Tag, :count).by(7)
    end
  end
end
