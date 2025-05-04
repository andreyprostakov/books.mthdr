require 'rails_helper'

RSpec.describe '/api/tags/full_entries' do
  describe 'PUT /:id' do
    subject(:send_request) do
      put "/api/tags/full_entries/#{tag.id}.json", params: { tag: tag_params }, headers: authorization_header
    end

    let(:tag) { create(:tag, name: 'old_name') }
    let(:tag_params) { { name: 'new_name' } }

    it 'updates the tag' do
      send_request

      expect(response).to be_successful
      expect(json_response).to be_empty
      expect(tag.reload.name).to eq('new_name')
    end
  end

  describe 'DELETE /:id' do
    subject(:send_request) do
      delete "/api/tags/full_entries/#{tag.id}.json", headers: authorization_header
    end

    let(:tag) { create(:tag, name: 'old_name') }

    it 'deletes the tag' do
      tag
      expect { send_request }.to change(Tag, :count).by(-1)

      expect(response).to be_successful
      expect(json_response).to be_empty
    end
  end
end
