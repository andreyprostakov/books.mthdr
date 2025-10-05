module Api
  module Authors
    class SearchController < Api::Authors::BaseController
      def show
        @entries = [] # TBD: reimplement search
      end
    end
  end
end
