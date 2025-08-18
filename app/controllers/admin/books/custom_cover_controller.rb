module Admin
  module Books
    class CustomCoverController < AdminController
      def destroy
        @book = Book.find(params[:book_id])
        @book.update!(aws_covers: nil)
        redirect_to admin_book_path(@book)
      end
    end
  end
end
