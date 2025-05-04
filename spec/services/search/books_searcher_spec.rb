require 'rails_helper'

RSpec.describe Search::BooksSearcher do
  describe '.search' do
    subject(:result) { described_class.search(search_key) }

    let(:search_key) { 'foo bar' }
    let(:search_result) { instance_double(Sunspot::Search::StandardSearch, hits: [search_hit]) }
    let(:search_hit) { instance_double(Sunspot::Search::Hit, highlights: [search_highlight], result: book) }
    let(:search_highlight) { instance_double(Sunspot::Search::Highlight, format: '*Foo* Baz') }
    let(:book) { build_stubbed(:book, title: 'Foo Baz') }

    before do
      allow(Book).to receive(:search) do
        search_result
      end
    end

    it 'returns an array of search results' do
      expect(result).to match [kind_of(described_class::Entry)]
      entry = result.first
      expect(entry.book_id).to eq(book.id)
      expect(entry.highlight).to eq(search_highlight.format)
    end
  end
end
