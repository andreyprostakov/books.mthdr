module Admin
  class AuthorBooksController < AdminController
    before_action :set_author

    # GET /admin/author/1/books/new
    def new
      @book = Admin::Book.new(author: @author)
      @form = Forms::BookForm.new(@book)
    end

    private

    def set_author
      @author = Admin::Author.find(params.expect(:author_id))
    end
  end
end
