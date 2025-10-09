require 'rails_helper'

RSpec.describe Admin::Authors::SyncStatusController do
  let(:author) { create(:author, synced_at: nil) }

  around do |example|
    Timecop.freeze(Time.current.change(usec: 0)) { example.run }
  end

  describe 'PUT /admin/authors/:id/sync_status' do
    let(:send_request) { put admin_author_sync_status_path(author), headers: authorization_header }

    it 'updates the synced_at' do
      send_request
      expect(author.reload.synced_at).to eq(Time.current)
    end

    it 'redirects with a message' do
      send_request
      expect(response).to redirect_to(admin_author_path(author))
      expect(flash[:notice]).to eq('Sync status was updated.')
    end
  end
end
