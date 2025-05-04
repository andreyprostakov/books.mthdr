require 'rails_helper'

RSpec.describe '/api/books/search' do
  let(:book) { build_stubbed(:book) }

  describe 'GET /' do
    subject(:send_request) { get '/api/books/search.json', params: params, headers: authorization_header }

    let(:params) { { key: 'SEARCH_KEY' } }
    let(:search_entry) do
      instance_double(Search::BooksSearcher::Entry,
                      book_id: book.id, title: book.title, highlight: book.title,
                      year: book.year_published, author_id: book.author_id)
    end

    before { allow(Search::BooksSearcher).to receive(:search).with('SEARCH_KEY').and_return([search_entry]) }

    it 'returns found matches' do
      send_request
      expect(response).to be_successful
      expect(json_response).to eq(
        [
          {
            book_id: book.id,
            title: book.title,
            highlight: book.title,
            year: book.year_published,
            author_id: book.author_id
          }
        ]
      )
    end
  end
end
