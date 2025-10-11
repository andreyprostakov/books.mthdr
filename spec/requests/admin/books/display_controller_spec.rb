require 'rails_helper'

RSpec.describe Admin::Books::DisplayController do
  describe 'GET /admin/books/display' do
    let(:send_request) { get admin_books_display_path, headers: authorization_header }
    let(:books) { create_list(:book, 3) }
    let(:cover_design) { create(:cover_design, name: 'default') }

    it 'renders the index template' do
      books
      cover_design

      send_request
      expect(assigns(:books)).to match_array(books)
      expect(response).to render_template('admin/books/display/show')
    end
  end
end
