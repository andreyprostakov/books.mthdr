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
        fetch_books_list_entries do |tuple|
          next if apply_to_existing_book(*tuple)

          book = build_book(*tuple)
          @books.push book
        end
      rescue StandardError => e
        @error = e.message
        Rails.logger.error(e.message)
      end

      def fetch_books_list_entries(&)
        @raw_data = InfoFetchers::Chats::AuthorBooksListExpert.new.ask_books_list(@author)
        JSON.parse(@raw_data).fetch('works').map(&)
      end

      def apply_to_existing_book(title, original_title, year, form, wikipedia_url)
        existing_book = @books.find do |book|
          book.title == title || (original_title.present? && book.original_title == original_title)
        end
        return false if existing_book.blank?

        existing_book.original_title = original_title if original_title.present?
        existing_book.year_published = year if year.present?
        existing_book.literary_form = form
        existing_book.wiki_url = wikipedia_url if wikipedia_url.present?
        true
      end

      def build_book(title, original_title, year, form, wikipedia_url)
        Book.new(
          author: @author,
          title: title,
          original_title: original_title,
          year_published: year,
          literary_form: form,
          wiki_url: wikipedia_url
        )
      end
    end
  end
end
