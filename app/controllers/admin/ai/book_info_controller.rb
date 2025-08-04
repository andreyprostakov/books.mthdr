module Admin
  module Ai
    class BookInfoController < Admin::AdminController
      def edit
        @book = fetch_book
        @edited_book = InfoFetchers::BookInfoFetcher.new.sync(fetch_book)
        @form = Forms::BookForm.new(@edited_book)
      end

      private

      def fetch_book
        Admin::Book.preload(tag_connections: :tag).find(params[:book_id])
      end
    end
  end
end
