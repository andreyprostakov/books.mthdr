module Admin
  class BooksController < AdminController
    before_action :set_book, only: %i[show edit update destroy]

    SORTING_MAP = %i[
      id
      title
      year_published
      goodreads_rating
      popularity
      created_at
      updated_at
    ].index_by(&:to_s).freeze

    # GET /admin/books
    def index
      @pagy, @admin_books = pagy(
        apply_sort(
          Admin::Book.preload(:author),
          SORTING_MAP
        )
      )
    end

    # GET /admin/books/1
    def show; end

    # GET /admin/books/new
    def new
      @book = Admin::Book.new
    end

    # GET /admin/books/1/edit
    def edit; end

    # POST /admin/books
    def create
      @book = Admin::Book.new(admin_book_params)

      respond_to do |format|
        if @book.save
          format.html { redirect_to @book, notice: t('notices.admin.books.create.success') }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/books/1
    def update
      respond_to do |format|
        if @book.update(admin_book_params)
          format.html { redirect_to @book, notice: t('notices.admin.books.update.success') }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/books/1
    def destroy
      @book.destroy!

      respond_to do |format|
        format.html do
          redirect_to admin_books_path, status: :see_other, notice: t('notices.admin.books.destroy.success')
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Admin::Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_book_params
      params.fetch(:book).permit(:title, :original_title, :year_published, :author_id, :goodreads_url,
                                 :goodreads_rating, :goodreads_popularity)
    end
  end
end
