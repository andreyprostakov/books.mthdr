require 'rails_helper'

RSpec.describe Admin::Books::GenerativeSummaryController, type: :request do
  describe 'POST /admin/books/:id/generative_summary' do
    let(:send_request) { post admin_book_generative_summary_path(book), headers: authorization_header }
    let(:book) { create(:book) }
    let(:summary_writer) { instance_double(InfoFetchers::Chats::BookSummaryWriter) }
    let(:summaries) do
      [
        { summary: 'SUMMARY_A', themes: 'theme_a', genre: 'genre_a', src: 'src_a' },
        { summary: 'SUMMARY_B', themes: 'theme_b', genre: 'genre_b', src: 'src_b' }
      ]
    end

    before do
      allow(InfoFetchers::Chats::BookSummaryWriter).to receive(:new).and_return(summary_writer)
      allow(summary_writer).to receive(:ask).and_return(summaries)
    end

    it 'prepares summaries' do
      send_request
      expect(assigns(:summaries)).to eq(summaries)
      expect(assigns(:all_themes)).to match_array(%w[theme_a theme_b])
    end

    it 'renders the index template' do
      send_request
      expect(response).to render_template('admin/books/generative_summary/create')
      expect(assigns(:book)).to eq(book)
      expect(assigns(:form)).to be_a(Forms::BookForm)
    end
  end
end
