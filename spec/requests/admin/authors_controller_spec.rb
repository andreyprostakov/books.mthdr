require 'rails_helper'

RSpec.describe Admin::AuthorsController do
  before do
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(ActionController::Base).to receive(:render)
    # rubocop:enable RSpec/AnyInstance
  end

  let(:valid_attributes) do
    {
      fullname: 'John Doe'
    }
  end

  let(:invalid_attributes) do
    {
      fullname: ''
    }
  end

  let(:author) { create(:author) }

  describe 'GET /admin/authors' do
    let(:send_request) { get admin_authors_path, headers: authorization_header }

    it 'renders a successful response' do
      send_request
      expect(response).to be_successful
    end
  end

  describe 'GET /admin/authors/:id' do
    let(:send_request) { get admin_author_path(author), headers: authorization_header }

    it 'renders a successful response' do
      send_request
      expect(response).to be_successful
    end
  end

  describe 'GET /admin/authors/new' do
    let(:send_request) { get new_admin_author_path, headers: authorization_header }

    it 'renders a successful response' do
      send_request
      expect(response).to be_successful
    end
  end

  describe 'GET /admin/authors/:id/edit' do
    let(:send_request) { get edit_admin_author_path(author), headers: authorization_header }

    it 'renders a successful response' do
      send_request
      expect(response).to be_successful
    end
  end

  describe 'POST /admin/authors' do
    context 'with valid parameters' do
      let(:send_request) do
        post admin_authors_path, params: { author: valid_attributes }, headers: authorization_header
      end

      it 'creates a new Author' do
        expect do
          send_request
        end.to change(Admin::Author, :count).by(1)
      end

      it 'redirects to the created author' do
        send_request
        expect(response).to redirect_to(admin_author_path(Admin::Author.last))
      end
    end

    context 'with invalid parameters' do
      let(:send_request) do
        post admin_authors_path(format: :html), params: { author: invalid_attributes }, headers: authorization_header
      end

      it 'does not create a new Author' do
        expect do
          send_request
        end.not_to change(Admin::Author, :count)
      end

      it 'renders a response with 422 status', pending: 'TODO: cant get request specs to respond with 422' do
        send_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /admin/authors/:id' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          fullname: 'Jane Doe'
        }
      end
      let(:send_request) do
        patch admin_author_path(author), params: { author: new_attributes }, headers: authorization_header
      end

      it 'updates the requested author' do
        send_request
        author.reload
        expect(author.fullname).to eq('Jane Doe')
      end

      it 'redirects to the author' do
        send_request
        expect(response).to redirect_to(admin_author_path(author))
      end
    end

    context 'with invalid parameters' do
      let(:send_request) do
        patch admin_author_path(author), params: { author: invalid_attributes }, headers: authorization_header
      end

      it 'renders a response with 422 status', pending: 'TODO: cant get request specs to respond with 422' do
        send_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /admin/authors/:id' do
    let(:send_request) { delete admin_author_path(author), headers: authorization_header }

    it 'destroys the requested author' do
      author
      expect do
        send_request
      end.to change(Admin::Author, :count).by(-1)
    end

    it 'redirects to the authors list' do
      send_request
      expect(response).to redirect_to(admin_authors_path)
    end
  end
end
