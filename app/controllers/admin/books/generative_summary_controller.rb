module Admin
  module Books
    class GenerativeSummaryController < AdminController
      def new
        @book = fetch_book
        @form = Forms::BookForm.new(@book)
        @summaries = InfoFetchers::Chats::BookSummaryWriter.new.ask(@book.title, @book.year_published, @book.author)
        @all_themes = @summaries.flat_map { |s| s[:themes].split(/,\s?/) }.uniq
      end

      private

      def fetch_book
        Admin::Book.preload(:genres, tag_connections: :tag).find(params[:book_id])
      end
    end
  end
end
