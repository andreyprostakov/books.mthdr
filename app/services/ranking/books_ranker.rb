# frozen_string_literal: true

module Ranking
  class BooksRanker
    class << self
      def update(book)
        return
        Ranking::Storages::BooksGlobalStorage.update(book)
        Ranking::Storages::BooksYearsStorage.update(book)
        Ranking::Storages::BooksAuthorsStorage.update(book)
        Ranking::Storages::AuthorsStorage.update(book)
      end

      def rank_global(book)
        return 0
        Ranking::Storages::BooksGlobalStorage.rank(book)
      end

      def rank_by_year(book)
        return 0
        Ranking::Storages::BooksYearsStorage.rank(book)
      end

      def rank_by_author(book)
        return 0
        Ranking::Storages::BooksAuthorsStorage.rank(book)
      end

      def rank_author(author)
        return 0
        Ranking::Storages::AuthorsStorage.rank(author)
      end
    end
  end
end
