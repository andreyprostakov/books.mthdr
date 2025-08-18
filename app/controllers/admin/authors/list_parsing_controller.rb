module Admin
  module Authors
    class ListParsingController < AdminController
      def new
        @author = Author.find(params[:author_id])
      end

      def create
        @author = Author.find(params[:author_id])
        @books_data = InfoFetchers::Chats::AuthorBooksListParser.new.parse_books_list(params[:text])
        prepare_list_preview(@books_data)
      end

      private

      def prepare_list_preview(books_data)
        @books = @author.books.to_a
        books_data.map do |book_data|
          title = book_data[:title]
          year = book_data[:year]
          type = book_data[:type]

          existing_book = @books.find do |book|
            book.title == title
          end
          if existing_book.present?
            existing_book.year_published = year if year.present?
            existing_book.literary_form = type if type.present?
            next
          end

          book = Book.new(
            author: @author,
            title: title,
            year_published: year,
            literary_form: type
          )
          @books.push book
        end
      rescue StandardError => e
        @error = e.message
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace.join("\n"))
      end
    end
  end
end
