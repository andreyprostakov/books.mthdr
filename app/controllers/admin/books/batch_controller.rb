module Admin
  module Books
    class BatchController < AdminController
      def edit
        @books = Book.where(id: params[:book_ids])
      end

      def update
        if apply_updates
          flash.now[:success] = t('notices.admin.books_batch.updates_applied')
          redirect_to @books.present? ? admin_book_path(@books.first) : admin_books_path
        else
          flash.now[:error] = t('notices.admin.books_batch.failed')
          render :edit
        end
      end

      private

      def apply_updates
        @books = []
        params.fetch(:batch).each do |_, book_params|
          book = book_params[:id].present? ? Book.find(book_params[:id]) : Book.new
          book.update!({
            title: book_params[:title],
            original_title: book_params[:original_title],
            year_published: book_params[:year_published],
            author_id: book_params[:author_id],
            goodreads_url: book_params[:goodreads_url],
            wiki_url: book_params[:wiki_url]
          }.compact)
          @books << book
        end
      end
    end
  end
end
