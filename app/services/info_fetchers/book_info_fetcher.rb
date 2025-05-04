module InfoFetchers
  class BookInfoFetcher < InfoFetchers::BaseFetcher
    def sync(book)
      ai_talker = AiClients::BookInfoFetcher.new
      info = ai_talker.ask_book_info(book.title, book.author)
      update_book(book, info)
      nil
    end

    private

    def update_book(book, info)
      book.update!(
        title: info.fetch('title'),
        original_title: info.fetch('original_title'),
        year_published: info.fetch('publishing_year'),
        goodreads_url: info.fetch('goodreads_url'),
        wiki_url: info.fetch('wiki_url'),
        tags: book.tags | extract_all_tags(info),
        summary: info.fetch('summary')
      )
      Rails.logger.info "Book ID=#{book.id} updated"
    end

    def extract_all_tags(info)
      [
        extrat_tags(info, 'genre', :genre),
        extrat_tags(info, 'themes', :theme),
        extrat_tags(info, 'series', :series)
      ].flatten
    end
  end
end
