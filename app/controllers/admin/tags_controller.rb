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

    def index
      @pagy, @admin_tags = pagy(
        apply_sort(
          ::Tag.preload(:tag_connections),
          SORTING_MAP,
          defaults: { sort_by: 'id', sort_order: 'desc' }
        )
      )
    end

    def show; end

    def new
      @tag = Tag.new
    end

    def edit; end

    def create
      @tag = Tag.new(admin_tag_params)

      respond_to do |format|
        if @tag.save
          format.html { redirect_to admin_tag_path(@tag), notice: t('notices.admin.tags.create.success') }
        else
          format.html { render :new, status: :unprocessable_content }
        end
      end
    end

    def update
      respond_to do |format|
        if @tag.update(admin_tag_params)
          format.html { redirect_to admin_tag_path(@tag), notice: t('notices.admin.tags.update.success') }
        else
          format.html { render :edit, status: :unprocessable_content }
        end
      end
    end

    def destroy
      @tag.destroy!

      respond_to do |format|
        format.html do
          redirect_to admin_tags_path, status: :see_other, notice: t('notices.admin.tags.destroy.success')
        end
      end
    end

    private

    def set_tag
      @tag = ::Tag.find(params[:id])
    end

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
