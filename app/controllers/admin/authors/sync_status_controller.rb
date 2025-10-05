module Admin
  module Authors
    class SyncStatusController < AdminController
      def create
        @author = Author.find(params[:author_id])
        @author.update(synced_at: Time.current.utc)
        redirect_to admin_author_path(@author), notice: 'Sync status updated'
      end
    end
  end
end
