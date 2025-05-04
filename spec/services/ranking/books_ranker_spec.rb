# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ranking::BooksRanker do
  describe '.rank_global' do
    subject(:result) { described_class.rank_global(book) }

    let(:book) { build_stubbed(:book, popularity: 100) }

    let(:stored_rank) { 333 }

    before do
      allow(Ranking::Storages::BooksGlobalStorage).to receive(:rank).with(book).and_return(stored_rank)
    end

    it 'delegates to BooksGlobalStorage' do
      expect(result).to eq(stored_rank)
    end
  end

  describe '.rank_by_year' do
    subject(:result) { described_class.rank_by_year(book) }

    let(:book) { build_stubbed(:book, popularity: 100) }

    let(:stored_rank) { 333 }

    before do
      allow(Ranking::Storages::BooksYearsStorage).to receive(:rank).with(book).and_return(stored_rank)
    end

    it 'delegates to BooksYearsStorage' do
      expect(result).to eq(stored_rank)
    end
  end

  describe '.rank_by_author' do
    subject(:result) { described_class.rank_by_author(book) }

    let(:book) { build_stubbed(:book, popularity: 100) }

    let(:stored_rank) { 333 }

    before do
      allow(Ranking::Storages::BooksAuthorsStorage).to receive(:rank).with(book).and_return(stored_rank)
    end

    it 'delegates to BooksAuthorsStorage' do
      expect(result).to eq(stored_rank)
    end
  end

  describe '.rank_author' do
    subject(:result) { described_class.rank_author(author) }

    let(:author) { build_stubbed(:author) }

    let(:stored_rank) { 333 }

    before do
      allow(Ranking::Storages::AuthorsStorage).to receive(:rank).with(author).and_return(stored_rank)
    end

    it 'delegates to AuthorsStorage' do
      expect(result).to eq(stored_rank)
    end
  end

  describe '.update' do
    subject(:call) { described_class.update(book) }

    let(:book) { build_stubbed(:book, popularity: 100) }

    it 'updates BooksGlobalStorage' do
      expect { call }.to change { Ranking::Storages::BooksGlobalStorage.rank(book) }.from(nil).to(1)
    end

    it 'updates BooksYearsStorage' do
      expect { call }.to change { Ranking::Storages::BooksYearsStorage.rank(book) }.from(nil).to(1)
    end

    it 'updates BooksAuthorsStorage' do
      expect { call }.to change { Ranking::Storages::BooksAuthorsStorage.rank(book) }.from(nil).to(1)
    end

    it 'updates AuthorsStorage' do
      expect { call }.to change { Ranking::Storages::AuthorsStorage.rank(book.author) }.from(nil).to(1)
    end
  end
end
