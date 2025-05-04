require 'rails_helper'

RSpec.describe '/api/authors/search' do
  let(:author) { build_stubbed(:author) }

  describe 'GET /' do
    subject(:send_request) { get '/api/authors/search.json', params: params, headers: authorization_header }

    let(:params) { { key: 'SEARCH_KEY' } }
    let(:author_search_entry) do
      instance_double(Search::AuthorsSearcher::Entry, author_id: author.id, highlight: author.fullname)
    end

    before { allow(Search::AuthorsSearcher).to receive(:search).with('SEARCH_KEY').and_return([author_search_entry]) }

    it 'returns found matches' do
      send_request
      expect(response).to be_successful
      expect(json_response).to eq([{ author_id: author.id, highlight: author.fullname }])
    end
  end
end
