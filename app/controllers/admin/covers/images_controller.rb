module Admin
  module Covers
    class ImagesController < AdminController
      def index
        @pagy, @books = pagy(
          Admin::Book.where.not(aws_covers: nil),
          limit: 6*10
        )
      end

      def destroy
        @book = Admin::Book.find(params[:id])
        @book.update!(aws_covers: nil)
        head :ok
      end
    end
  end
end
