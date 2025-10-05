require 'rails_helper'

RSpec.describe InfoFetchers::Chats::AuthorUpdater do
  subject(:updater) { described_class.new }

  describe '#apply_updates' do
    subject(:call) { updater.apply_updates(author) }

    let(:author) { create(:author) }
    let(:ai_talker) { instance_double(InfoFetchers::Chats::AuthorsExpert) }
    let(:author_info) do
      {
        'fullname' => 'Fyodor Dostoevsky',
        'original_name' => 'Фёдор Достоевский',
        'countries' => 'Russia',
        'birth_year' => 1821,
        'death_year' => 1881
      }
    end
    let(:books_info) do
      [
        {
          'title' => 'Crime and Punishment',
          'original_title' => 'Преступление и наказание',
          'publishing_year' => 1866
        },
        {
          'title' => 'The Brothers Karamazov',
          'original_title' => 'Братья Карамазовы',
          'publishing_year' => 1880
        }
      ]
    end
    let(:info) { { 'author' => author_info, 'books' => books_info } }

    before do
      allow(InfoFetchers::Chats::AuthorsExpert).to receive(:new).and_return(ai_talker)
      allow(ai_talker).to receive(:ask_books_list).with(author.fullname).and_return(info)
      allow(Rails.logger).to receive(:info)
      allow(Book).to receive(:find_or_initialize_by).and_call_original
    end

    it 'fetches author info and updates author' do
      call

      expect(author.original_fullname).to eq(author_info['original_name'])
      expect(author.tags).to contain_exactly(instance_of(Tag))
      expect(author.birth_year).to eq(author_info['birth_year'])
      expect(author.death_year).to eq(author_info['death_year'])
    end

    it 'fetches books info and updates books' do
      call

      books_info.each do |book_info|
        expect(Book).to have_received(:find_or_initialize_by).with(
          author_id: author.id,
          title: book_info['title']
        )
      end
    end

    it 'logs author update' do
      call

      expect(Rails.logger).to have_received(:info).with("Author ID=#{author.id} updated")
    end

    it 'logs book updates' do
      call

      books_info.each do |book_info|
        book = Book.find_by(title: book_info['title'])
        expect(Rails.logger).to have_received(:info).with("Book ID=#{book.id} updated")
      end
    end

    it 'returns nil' do
      expect(call).to be_nil
    end
  end
end
