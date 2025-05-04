require 'rails_helper'

RSpec.describe '/api/tags/search' do
  let(:tag) { build_stubbed(:tag) }

  describe 'GET /' do
    subject(:send_request) { get '/api/tags/search.json', params: params, headers: authorization_header }

    let(:params) { { key: 'SEARCH_KEY' } }
    let(:search_entry) do
      instance_double(Search::TagsSearcher::Entry, tag_id: tag.id, highlight: tag.name)
    end

    before { allow(Search::TagsSearcher).to receive(:search).with('SEARCH_KEY').and_return([search_entry]) }

    it 'returns found matches' do
      send_request
      expect(response).to be_successful
      expect(json_response).to eq([{ tag_id: tag.id, highlight: tag.name }])
    end
  end
end
