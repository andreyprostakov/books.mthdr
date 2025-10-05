module Admin
  module Authors
    class SearchController < AdminController
      def create
        @key = params[:key]
        @authors = perform_search
      end

      private

      def perform_search
        return [] if @key.blank?

        Author.preload(:books).where('fullname LIKE ?', "%#{@key}%").order(id: :desc).to_a
      end
    end
  end
end
