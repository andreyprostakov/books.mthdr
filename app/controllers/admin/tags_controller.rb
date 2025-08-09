module Admin
  class TagsController < AdminController
    before_action :set_tag, only: %i[show edit update destroy]

    SORTING_MAP = %i[
      id
      name
      category
      created_at
      updated_at
    ].index_by(&:to_s).freeze

    # GET /admin/tags
    def index
      @pagy, @admin_tags = pagy(
        apply_sort(
          ::Tag.preload(:tag_connections),
          SORTING_MAP,
          defaults: { sort_by: 'id', sort_order: 'desc' }
        )
      )
    end

    # GET /admin/tags/1
    def show; end

    # GET /admin/tags/new
    def new
      @tag = Admin::Tag.new
    end

    # GET /admin/tags/1/edit
    def edit; end

    # POST /admin/tags
    def create
      @tag = Admin::Tag.new(admin_tag_params)

      respond_to do |format|
        if @tag.save
          format.html { redirect_to admin_tag_path(@tag), notice: t('notices.admin.tags.create.success') }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/tags/1
    def update
      respond_to do |format|
        if @tag.update(admin_tag_params)
          format.html { redirect_to admin_tag_path(@tag), notice: t('notices.admin.tags.update.success') }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/tags/1
    def destroy
      @tag.destroy!

      respond_to do |format|
        format.html do
          redirect_to admin_tags_path, status: :see_other, notice: t('notices.admin.tags.destroy.success')
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = ::Tag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_tag_params
      params.fetch(:tag).permit(:name, :category)
    end

    def apply_sort(scope, _sorting_map, defaults: {})
      apply_sorting_defaults(defaults)
      return super unless sorting_params[:sort_by] == 'tag_connections_size'

      direction = sorting_params[:sort_order] == 'desc' ? :desc : :asc
      scope.left_joins(:tag_connections)
           .group('tags.id')
           .order("COUNT(tag_connections.id) #{direction}")
    end
  end
end
