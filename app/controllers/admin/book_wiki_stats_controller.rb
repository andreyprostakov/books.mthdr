module Admin
  class BookWikiStatsController < Admin::AdminController
    def update
      book = Admin::Book.find(params[:book_id])
      initial_count = book.wiki_page_stats.count
      InfoFetchers::Wiki::BookSyncer.new(book).sync!
      if book.wiki_popularity > initial_count
        redirect_to book, notice: t('notices.admin.book_wiki_stats.update.success')
      else
        redirect_to book, alert: t('notices.admin.book_wiki_stats.update.none')
      end
    end
  end
end
