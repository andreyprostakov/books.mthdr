module Admin
  module BaseHelper
    def admin_timestamp(time)
      return if time.blank?

      time.strftime('%y-%m-%d %H:%M:%S')
    end

    def sortable_table_column(label, parameter)
      if params[:sort_by] == parameter
        if params[:sort_order] == 'desc'
          link_to("#{label} ↑", url_for(sort_by: parameter, sort_order: 'asc', page: 1))
        else
          link_to("#{label} ↓", url_for(sort_by: parameter, sort_order: 'desc', page: 1))
        end
      else
        link_to(label, url_for(sort_by: parameter, page: 1))
      end
    end
  end
end
