module Admin
  module Covers
    class StandardController < AdminController
      def index
        @pagy, @books = pagy(
          Admin::Book.preload(:author),
          limit: 6*10
        )
      end
    end
  end
end
