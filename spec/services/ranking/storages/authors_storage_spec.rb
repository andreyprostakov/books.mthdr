# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ranking::Storages::AuthorsStorage do
  describe '.update' do
    subject { described_class.update(book) }

    let(:book) { build_stubbed(:book, author: author) }
    let(:author) { build_stubbed(:author) }

    before { allow(author).to receive(:popularity).and_return(1500) }

    it 'writes given author popularity into the set' do
      expect { subject }.to change { Rails.redis.zscore(described_class::KEY, author.id) }.from(nil).to(1500)
    end

    context 'when book had a different author' do
      before do
        book.author = previous_author
        allow(previous_author).to receive(:popularity).and_return(2000)
        described_class.update(book)

        book.author = author
        allow(book).to receive_messages(author_id_previously_changed?: true,
                                        author_id_previously_was: previous_author.id)
      end

      let(:previous_author) { create(:author) }

      it 'recalculates previous authors popularity' do
        expect { subject }.to change { Rails.redis.zscore(described_class::KEY, previous_author.id) }.from(2000).to(0)
      end
    end
  end

  describe '.rank' do
    subject { described_class.rank(author) }

    let(:book) { build_stubbed(:book, author: author) }
    let(:author) { build_stubbed(:author) }

    before { allow(author).to receive(:popularity).and_return(1500) }

    context 'when the author has not been registered before' do
      it { is_expected.to be_nil }
    end

    context 'when the author has been registered' do
      before do
        described_class.update(book)
        allow(another_author).to receive(:popularity).and_return(another_popularity)
        described_class.update(another_authors_book)
      end

      let(:another_author) { create(:author) }
      let(:another_authors_book) { build_stubbed(:book, author: another_author) }
      let(:another_popularity) { 2000 }

      context 'when an author with greater popularity has been registered' do
        it 'returns a lesser rank' do
          expect(subject).to eq(2)
        end
      end

      context 'when an author with lesser popularity has been registered' do
        let(:another_popularity) { 1000 }

        it 'returns top rank' do
          expect(subject).to eq(1)
        end
      end
    end
  end
end
