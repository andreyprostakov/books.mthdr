module Admin
  module Authors
    class WikiStatsController < AdminController
      def update
        author = Author.find(params[:author_id])
        to_be_synced = author.books.select { |book| book.wiki_url.present? && book.wiki_popularity.zero? }
        if to_be_synced.any?
          to_be_synced.each do |book|
            InfoFetchers::Wiki::BookSyncer.new(book).sync!
          end
          redirect_to admin_author_path(author), notice: t('notices.admin.author_wiki_stats.update.success')
        else
          redirect_to admin_author_path(author), alert: t('notices.admin.author_wiki_stats.update.none')
        end
      end
    end
  end
end
