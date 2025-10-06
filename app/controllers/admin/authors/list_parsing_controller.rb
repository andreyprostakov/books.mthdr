module Admin
  module Authors
    class ListParsingController < AdminController
      def new
        @author = Author.find(params[:author_id])
      end

      def create
        @author = Author.find(params[:author_id])
        prepare_list_preview
      end

      private

      def prepare_list_preview
        @books = @author.books.to_a
        fetch_books_list_entries do |title, year, type|
          next if apply_to_existing_book(title, year, type)

          book = build_book(title, year, type)
          @books.push book
        end
      rescue StandardError => e
        @error = e.message
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace.join("\n"))
      end

      def fetch_books_list_entries(&)
        @raw_data = InfoFetchers::Chats::AuthorBooksListParser.new.parse_books_list(params[:text])
        @raw_data.map do |book_data|
          title = book_data[:title]
          year = book_data[:year]
          type = book_data[:type]
          yield(title, year, type)
        end
      end

      def apply_to_existing_book(title, year, type)
        existing_book = @books.find do |book|
          book.title == title
        end
        return false if existing_book.blank?

        existing_book.year_published = year if year.present?
        existing_book.literary_form = type if type.present?
        true
      end

      def build_book(title, year, type)
        Book.new(
          author: @author,
          title: title,
          year_published: year,
          literary_form: type
        )
      end
    end
  end
end
