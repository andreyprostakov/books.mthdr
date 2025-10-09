require 'rails_helper'

RSpec.describe Admin::Books::SearchController do
  describe 'POST /admin/books/search' do
    let(:send_request) { post admin_books_search_path, params: params, headers: authorization_header }
    let(:params) { { key: '_B' } }
    let(:books) do
      [
        create(:book, title: 'BOOK_A'),
        create(:book, title: 'BOOK_B')
      ]
    end

    it 'renders the index template' do
      books

      send_request
      expect(response).to render_template('admin/books/search/create')
      expect(assigns(:books)).to match_array(books.values_at(1))
    end
  end
end
