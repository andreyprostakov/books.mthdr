module Admin
  module Books
    class DisplayController < AdminController
      def show
        @pagy, @books = pagy(
          Book.preload(:author),
          limit: 6 * 10
        )
      end
    end
  end
end
