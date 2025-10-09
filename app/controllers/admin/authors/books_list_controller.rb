require 'csv'

module Admin
  module Authors
    class BooksListController < AdminController
      def create
        @author = Author.preload(:books).find(params[:author_id])
        fetch_list
      end

      private

      def fetch_list
        @books = @author.books.to_a
        fetch_books_list_entries do |attributes|
          next if apply_to_existing_book(attributes)

          book = build_book(attributes)
          @books.push book
        end
      rescue StandardError => e
        @error = e.message
        Rails.logger.error(e.message)
      end

      def fetch_books_list_entries(&)
        @raw_data = InfoFetchers::Chats::AuthorBooksListExpert.new.ask_books_list(@author)
        JSON.parse(@raw_data).fetch('works').map do |(title, original_title, year, form, wikipedia_url)|
          yield({
            title: title,
            original_title: original_title,
            year_published: year,
            literary_form: form,
            wiki_url: wikipedia_url
          }.compact_blank)
        end
      end

      def apply_to_existing_book(attributes)
        existing_book = @books.find do |book|
          book.title == attributes[:title] ||
            (attributes[:original_title].present? && book.original_title == attributes[:original_title])
        end
        return false if existing_book.blank?

        existing_book.assign_attributes(attributes)
        true
      end

      def build_book(attributes)
        Book.new(attributes.merge(author: @author))
      end
    end
  end
end
