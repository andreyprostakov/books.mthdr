# frozen_string_literal: true

module Api
  module Books
    class PopularityController < Api::Books::BaseController
      before_action :fetch_book, only: :update

      def update
        return if GoodreadsStatsUpdater.update(@book)

        render json: { errors: @book.errors }, status: :unprocessable_content
      end
    end
  end
end
