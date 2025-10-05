require 'rails_helper'

RSpec.describe '/api/authors/search' do
  let(:author) { build_stubbed(:author) }

  describe 'GET /' do
    subject(:send_request) { get '/api/authors/search.json', params: params, headers: authorization_header }

    let(:params) { { key: 'SEARCH_KEY' } }

    it 'returns found matches' do
      send_request
      expect(response).to be_successful
      expect(json_response).to eq([])
    end
  end
end
