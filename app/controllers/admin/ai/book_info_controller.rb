module Admin
  module Ai
    class BookInfoController < Admin::AdminController
      def update
        @book = Admin::Book.find(params[:book_id])
        InfoFetchers::BookInfoFetcher.new.sync(@book)
        redirect_to admin_book_path(@book), notice: t('notices.admin.books.generate_info.success')
      end
    end
  end
end
