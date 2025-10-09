require 'rails_helper'

RSpec.describe Admin::Authors::SearchController do
  describe 'POST /admin/authors/search' do
    let(:send_request) { post admin_authors_search_path, params: params, headers: authorization_header }
    let(:params) { { key: 'B' } }
    let(:authors) { [create(:author, fullname: 'AUTHOR_A'), create(:author, fullname: 'AUTHOR_B')] }

    before { authors }

    it 'renders the results' do
      send_request
      expect(response).to be_successful
      expect(response).to render_template 'admin/authors/search/create'
      expect(assigns(:authors)).to eq(authors.values_at(1))
    end
  end
end
