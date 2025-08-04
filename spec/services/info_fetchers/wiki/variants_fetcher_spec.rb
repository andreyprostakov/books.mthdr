require 'rails_helper'

RSpec.describe InfoFetchers::Wiki::VariantsFetcher do
  describe '#fetch_variants' do
    subject(:call) { described_class.new.fetch_variants(page_name, locale) }

    let(:page_name) { 'Crime_and_Punishment' }
    let(:locale) { 'en' }

    let(:expected_url) do
      "https://en.wikipedia.org/w/api.php"\
      "?action=query&format=json&lllimit=500&prop=langlinks&titles=Crime_and_Punishment"
    end
    let(:service_api_response) do
      {
        'query' => {
          'pages' => {
            '123' => {
              'langlinks' => [
                { 'lang' => 'en', '*' => 'Crime and Punishment' },
                { 'lang' => 'ru', '*' => 'Преступление и наказание' }
              ]
            }
          }
        }
      }
    end

    before do
      stub_request(:get, expected_url).to_return(status: 200, body: service_api_response.to_json)
    end

    it 'returns the variants' do
      expect(call).to eq(
        'en' => 'Crime and Punishment',
        'ru' => 'Преступление и наказание'
      )
    end

    context 'when the service returns an error' do
      before do
        stub_request(:get, expected_url).to_return(status: 500)
      end

      it 'returns an empty hash' do
        expect(call).to eq({})
      end
    end
  end
end
