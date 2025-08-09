module Admin
  class AuthorsController < AdminController
    before_action :set_author, only: %i[show edit update destroy]

    SORTING_MAP = %i[
      id
      fullname
      birth_year
      created_at
      updated_at
    ].index_by(&:to_s).freeze

    BOOKS_SORTING_MAP = %i[
      id
      title
      year_published
      wiki_popularity
      created_at
      updated_at
    ].index_by(&:to_s).freeze

    # GET /admin/authors
    def index
      @pagy, @admin_authors = pagy(
        apply_sort(
          Admin::Author.all,
          SORTING_MAP,
          defaults: { sort_by: 'id', sort_order: 'desc' }
        )
      )
    end

    # GET /admin/authors/1
    def show
      @admin_books = apply_sort(
        Admin::Book.by_author(@author),
        BOOKS_SORTING_MAP,
        defaults: { sort_by: 'year_published', sort_order: 'desc' }
      )
    end

    # GET /admin/authors/new
    def new
      @author = Admin::Author.new
    end

    # GET /admin/authors/1/edit
    def edit; end

    # POST /admin/authors
    def create
      @author = Admin::Author.new(admin_author_params)

      respond_to do |format|
        if @author.save
          format.html { redirect_to @author, notice: t('notices.admin.authors.create.success') }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/authors/1
    def update
      respond_to do |format|
        if @author.update(admin_author_params)
          format.html { redirect_to @author, notice: t('notices.admin.authors.update.success') }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/authors/1
    def destroy
      @author.destroy!

      respond_to do |format|
        format.html do
          redirect_to admin_authors_path, status: :see_other, notice: t('notices.admin.authors.destroy.success')
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Admin::Author.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def admin_author_params
      params.fetch(:author).permit(:fullname)
    end
  end
end
