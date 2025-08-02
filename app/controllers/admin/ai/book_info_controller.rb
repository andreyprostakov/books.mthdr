module Admin
  module Ai
    class BookInfoController < Admin::AdminController
      def edit
        fetch_book
      end

      def update
        fetch_book
        InfoFetchers::BookInfoFetcher.new.sync(@book)
        redirect_to admin_book_path(@book), notice: t('notices.admin.books.generate_info.success')
      end

      private

      def fetch_book
        @book = Admin::Book.find(params[:book_id])
      end
    end
  end
end
