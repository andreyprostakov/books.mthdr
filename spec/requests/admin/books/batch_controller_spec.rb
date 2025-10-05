require 'rails_helper'

RSpec.describe Admin::Books::BatchController do
  before do
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(ActionController::Base).to receive(:render)
    # rubocop:enable RSpec/AnyInstance
  end

  describe 'GET /admin/books/batch/edit' do
    let(:send_request) { get admin_books_batch_path, book_ids: [book.id], headers: authorization_header }

    it 'renders a successful response' do
      send_request
      expect(response).to be_successful
    end
  end
end
