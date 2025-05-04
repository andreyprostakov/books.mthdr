module Admin
  module Ai
    class ChatsController < AdminController
      before_action :set_chat, only: :show

      SORTING_MAP = %i[
        id
        model_id
        created_at
        updated_at
      ].index_by(&:to_s).freeze

      # GET /admin/ai/chats
      def index
        @pagy, @chats = pagy(
          apply_sort(
            ::Ai::Chat.preload(:messages),
            SORTING_MAP
          )
        )
      end

      # GET /admin/ai/chats/1
      def show
        @messages = @chat.messages.order(created_at: :asc)
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_chat
        @chat = ::Ai::Chat.find(params[:id])
      end
    end
  end
end
