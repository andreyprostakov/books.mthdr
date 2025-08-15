require 'csv'

module Admin
  module Authors
    class BooksListController < AdminController
      def create
        @author = Author.preload(:books).find(params[:author_id])
        @books = fetch_list
      end

      private

      def fetch_list
        @raw_data = InfoFetchers::Chats::AuthorBooksListExpert.new.ask_books_list(@author)
        CSV.parse(@raw_data, quote_char: nil).map do |row|
          title, original_title, year, source = row.map(&:strip)
          title = clean_title(title)
          original_title = clean_title(original_title)
          existing_book = @author.books.find {|book| book.title == title || book.original_title == original_title}
          existing_book || @author.books.new(
            title: title,
            original_title: original_title,
            year_published: year
          )
        end
      rescue StandardError => e
        Rails.logger.error(e.message)
        []
      end

      def clean_title(title)
        title.gsub(/^"(.*)".*$/, '\1')
      end
    end
  end
end
