require 'rails_helper'

RSpec.describe '/api/tags/search' do
  let(:tag) { build_stubbed(:tag) }

  describe 'GET /' do
    subject(:send_request) { get '/api/tags/search.json', params: params, headers: authorization_header }

    let(:params) { { key: 'SEARCH_KEY' } }

    it 'returns found matches' do
      send_request
      expect(response).to be_successful
      expect(json_response).to eq([])
    end
  end
end
