require 'rails_helper'

RSpec.describe Admin::Authors::BooksListController do
  let(:author) { create(:author) }

  describe 'POST /admin/authors/:id/books_list' do
    let(:send_request) { post admin_author_books_list_path(author), headers: authorization_header }

    let(:books) do
      [
        create(:book, author: author, title: 'BOOK_1', original_title: 'ORIGINAL_1', year_published: 2021,
                      literary_form: 'type_1', wiki_url: 'WIKI_URL_1'),
        create(:book, author: author, title: 'BOOK_2', original_title: 'ORIGINAL_2', year_published: 2022,
                      literary_form: 'type_2', wiki_url: 'WIKI_URL_2'),
        create(:book, author: author, title: 'BOOK_3', original_title: 'ORIGINAL_3', year_published: 2023,
                      literary_form: 'type_3', wiki_url: 'WIKI_URL_3')
      ]
    end
    let(:ai_talker) { instance_double(InfoFetchers::Chats::AuthorBooksListExpert) }
    let(:books_list_info) do
      {
        'works' => [
          ['BOOK_1', 'ORIGINAL_1', 2025, 'type_11', 'WIKI_URL_11'],
          ['BOOK_2_DIFFERENT', 'ORIGINAL_2', 2025, 'type_22', 'WIKI_URL_22'],
          ['BOOK_4', 'ORIGINAL_4', 2024, 'type_4', 'WIKI_URL_4']
        ]
      }.to_json
    end

    before do
      books
      allow(InfoFetchers::Chats::AuthorBooksListExpert).to receive(:new).and_return(ai_talker)
      allow(ai_talker).to receive(:ask_books_list).with(author).and_return(books_list_info)
    end

    it 'fetches books info' do
      send_request
      expect(response).to be_successful
      expect(assigns(:books).pluck(:id, :title, :original_title, :year_published, :literary_form, :wiki_url)).to eq(
        [
          [books[0].id, 'BOOK_1', 'ORIGINAL_1', 2025, 'type_11', 'WIKI_URL_11'],
          [books[1].id, 'BOOK_2_DIFFERENT', 'ORIGINAL_2', 2025, 'type_22', 'WIKI_URL_22'],
          [books[2].id, 'BOOK_3', 'ORIGINAL_3', 2023, 'type_3', 'WIKI_URL_3'],
          [nil, 'BOOK_4', 'ORIGINAL_4', 2024, 'type_4', 'WIKI_URL_4']
        ]
      )
    end

    it 'renders the template' do
      send_request
      expect(response).to be_successful
      expect(response).to render_template 'admin/authors/books_list/create'
    end
  end
end
