require 'rails_helper'

RSpec.describe Admin::Authors::ListParsingController do
  let(:author) { create(:author) }

  describe 'GET /admin/authors/:id/list_parsing/new' do
    let(:send_request) { get new_admin_author_list_parsing_path(author), headers: authorization_header }

    it 'renders the new template' do
      send_request
      expect(response).to be_successful
      expect(response).to render_template 'admin/authors/list_parsing/new'
    end
  end

  describe 'POST /admin/authors/:id/list_parsing' do
    let(:send_request) { post admin_author_list_parsing_path(author), params: params, headers: authorization_header }
    let(:params) { { text: "LINE_1\nLINE_2\nLINE_3" } }
    let(:parser) { instance_double(InfoFetchers::Chats::AuthorBooksListParser) }
    let(:books) do
      [
        create(:book, author: author, title: 'TITLE_1', year_published: '2020', literary_form: 'TYPE_1'),
        create(:book, author: author, title: 'TITLE_2', year_published: '2020', literary_form: 'TYPE_1')
      ]
    end

    before do
      books
      allow(InfoFetchers::Chats::AuthorBooksListParser).to receive(:new).and_return(parser)
      allow(parser).to receive(:parse_books_list).with(params[:text]).and_return([
        { title: 'TITLE_1', year: '2021', type: 'TYPE_2' },
        { title: 'TITLE_2_DIFFERENT', year: '2022', type: 'TYPE_2' },
        { title: 'TITLE_3', year: '2023', type: 'TYPE_3' }
      ])
    end

    it 'prepares and applies book updates and renders the new template' do
      send_request
      expect(response).to be_successful
      expect(response).to render_template 'admin/authors/list_parsing/create'
      expect(assigns(:books).pluck(:id, :title, :year_published, :literary_form)).to eq([
        [books[0].id, 'TITLE_1', 2021, 'TYPE_2'],
        [books[1].id, 'TITLE_2', 2020, 'TYPE_1'],
        [nil, 'TITLE_2_DIFFERENT', 2022, 'TYPE_2'],
        [nil, 'TITLE_3', 2023, 'TYPE_3']
      ])
    end
  end
end
