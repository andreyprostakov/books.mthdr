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
        @raw_data = InfoFetchers::Chats::AuthorBooksListExpert.new.ask_books_list(@author)
        JSON.parse(@raw_data).fetch("works").map do |row|
          title, original_title, year, wikipedia_url = row
          existing_book = @books.find do |book|
            book.title == title || (original_title.present? && book.original_title == original_title)
          end
          if existing_book.present?
            existing_book.wiki_url = existing_book.wiki_url.presence || wikipedia_url
            existing_book.original_title = existing_book.original_title.presence || original_title
            next
          end

          book = Book.new(
            author: @author,
            title: title,
            original_title: original_title,
            year_published: year
          )
          @books.push book
        end
      rescue StandardError => e
        @error = e.message
        Rails.logger.error(e.message)
      end
    end
  end
end
