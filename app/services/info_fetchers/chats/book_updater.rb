class InfoFetchers::Chats::BookUpdater < InfoFetchers::BaseFetcher
  def prepare_updates(book)
    ai_talker = InfoFetchers::Chats::BooksExpert.new
    info = ai_talker.ask_book_info(book.original_title.presence || book.title, book.year_published, book.author)
    modify_book(book, info)
    book
  end

  private

  def modify_book(book, info)
    book.assign_attributes(
      title: info.fetch('title'),
      original_title: info.fetch('original_title'),
      year_published: info.fetch('publishing_year'),
      summary: info.fetch('summary')
    )
    tags = extract_all_tags(info)
    modify_tag_connections(book, tags)
  end

  def extract_all_tags(info)
    [
      extract_tags(info, 'genre', :genre),
      extract_tags(info, 'themes', :theme),
      extract_tags(info, 'series', :series)
    ].flatten.uniq
  end

  def modify_tag_connections(book, tags)
    tags_to_add = tags.to_set
    book.tag_connections.each do |tag_connection|
      if tag_connection.tag.in?(tags_to_add)
        tags_to_add.delete(tag_connection.tag)
      else
        tag_connection.mark_for_destruction
      end
    end
    tags_to_add.each do |tag|
      book.tag_connections.build(tag: tag)
    end
  end
end
