module Admin
  class AdminController < ApplicationController
    layout 'admin'
    include Pagy::Backend

    private

    def apply_sort(scope, sorting_map)
      sorting_attribute = sorting_map[params[:sort_by]]
      return scope if sorting_attribute.nil?

      scope.order(sorting_attribute => (params[:sort_order] == 'desc' ? :desc : :asc))
    end
  end
end
