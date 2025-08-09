class InfoFetchers::Wiki::BookSyncer
  def initialize(book)
    @book = book
  end

  def sync!
    raise "No wiki_url for book #{book.id}" if book.wiki_url.blank?

    stats = book.wiki_page_stats | initialize_page_stats
    sync_page_stats(stats)

    book.wiki_page_stats.reload
    book.update!(wiki_popularity: book.wiki_page_stats.sum(&:views))
  end

  private

  attr_reader :book

  def initialize_page_stats
    variants = fetch_variants
    variants.map do |locale, name|
      next if book.wiki_page_stats.find {|stat| stat.locale == locale}

      WikiPageStat.new(entity: book, locale: locale, name: name)
    end.compact
  end

  def fetch_variants
    name, locale = fetch_base_page_parts
    # InfoFetchers::Wiki::VariantsFetcher.new.fetch_variants(name, locale)
    {locale => name}
  end

  def fetch_base_page_parts
    name, locale = InfoFetchers::Wiki::UrlParser.extract_base_name_and_locale(book.wiki_url)
    raise "Can't extract base name and locale from #{book.wiki_url}" if name.blank? || locale.blank?

    [name, locale]
  end

  def sync_page_stats(stats)
    stats.each do |wiki_page_stat|
      views, views_last_month = InfoFetchers::Wiki::ViewsFetcher.new.fetch(wiki_page_stat.name, wiki_page_stat.locale,
        last_synced_at: wiki_page_stat.views_synced_at)
      next if views.nil? || views_last_month.nil?

      wiki_page_stat.views ||= 0
      wiki_page_stat.views += views - (wiki_page_stat.views_last_month || 0)
      wiki_page_stat.update!(views_last_month: views_last_month, views_synced_at: Time.now.utc)
    end
  end
end
