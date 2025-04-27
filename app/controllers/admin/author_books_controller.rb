module Admin
  class AuthorBooksController < AdminController
    before_action :set_author

    SORTING_MAP = %i[
      id
      title
      year_published
      goodreads_rating
      popularity
      created_at
      updated_at
    ].index_by(&:to_s).freeze

    # GET /admin/author/books
    def index
      @pagy, @admin_books = pagy(
        apply_sort(
          Admin::Book.preload(:author).by_author(@author),
          SORTING_MAP
        )
      )
    end

    # GET /admin/author/1/books/new
    def new
      @book = Admin::Book.new(author: @author)
    end

    private

    def set_author
      @author = Admin::Author.find(params.expect(:author_id))
    end
  end
end
