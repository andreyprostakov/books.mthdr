module Admin
  class BooksController < AdminController
    before_action :set_book, only: %i[show edit update destroy]

    SORTING_MAP = %i[
      id
      title
      year_published
      wiki_popularity
      created_at
      updated_at
    ].index_by(&:to_s).freeze

    # GET /admin/books
    def index
      @pagy, @admin_books = pagy(
        apply_sort(
          Admin::Book.preload(:author),
          SORTING_MAP,
          defaults: { sort_by: 'id', sort_order: 'desc' }
        )
      )
    end

    # GET /admin/books/1
    def show
      @next_book = begin
        scope = Book.where(author_id: @book.author_id).where('id != ?', @book.id).to_a
        scope.find { |b| b.summary.blank? } ||
          scope.find { |b| b.wiki_url.present? && b.wiki_popularity.blank? } ||
          scope.sample
      end
    end

    # GET /admin/books/new
    def new
      @book = Admin::Book.new
      @form = Forms::BookForm.new(@book)
    end

    # GET /admin/books/1/edit
    def edit
      @form = Forms::BookForm.new(@book)
    end

    # POST /admin/books
    def create
      @book = Admin::Book.new
      @form = Forms::BookForm.new(@book)
      respond_to do |format|
        if @form.update(admin_book_params)
          format.html { redirect_to @book, notice: t('notices.admin.books.create.success') }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/books/1
    def update
      @form = Forms::BookForm.new(@book)
      respond_to do |format|
        if @form.update(admin_book_params)
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
                                 :summary, :wiki_url, tag_names: [])
    end
  end
end
