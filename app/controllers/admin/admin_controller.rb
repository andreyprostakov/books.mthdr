module Admin
  class AdminController < ApplicationController
    layout 'admin'
    include Pagy::Backend

    helper_method :sorting_params

    private

    def apply_sort(scope, sorting_map, defaults: {})
      apply_sorting_defaults(defaults)
      sorting_attribute = sorting_map[sorting_params[:sort_by]]
      return scope if sorting_attribute.nil?

      scope.order(sorting_attribute => (sorting_params[:sort_order] == 'desc' ? :desc : :asc))
    end

    def apply_sorting_defaults(defaults)
      @sorting_params = defaults.merge(sorting_params)
    end

    def sorting_params
      @sorting_params ||= {sort_by: params[:sort_by], sort_order: params[:sort_order]}.compact
    end
  end
end
