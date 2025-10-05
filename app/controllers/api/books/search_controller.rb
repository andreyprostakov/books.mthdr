module Api
  module Books
    class SearchController < Api::Authors::BaseController
      def show
        @entries = [] # TBD: reimplement search
      end
    end
  end
end
