# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoodreadsStatsScraper do
  describe '.extract_stats' do
    subject { described_class.extract_stats(book) }

    let(:book) { build_stubbed(:book, goodreads_url: 'https://www.goodreads.com/book/show/2452383.The_Chimes') }
    let(:test_goodreads_page) { file_fixture('goodreads_test.html').read }

    before do
      http_response = instance_double(HTTParty::Response)
      allow(HTTParty).to receive(:get).with(book.goodreads_url).and_return(http_response)
      allow(http_response).to receive(:body).and_return(test_goodreads_page)
    end

    it 'fetches data from HTML page' do
      expect(subject).to match(
        rating: 3.3,
        popularity: 341
      )
    end

    context 'when the book has no goodreads_url' do
      before { book.goodreads_url = nil }

      it 'returns empty hash' do
        expect(subject).to eq({})
      end
    end
  end
end
