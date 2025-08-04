class InfoFetchers::Wiki::BookSyncer
  def initialize(book)
    @book = book
  end

  def sync!
    raise "No wiki_url for book #{book.id}" if book.wiki_url.blank?

    if book.wiki_page_stats.empty?
      initialize_page_stats
    end

    sync_page_stats

    book.update!(wiki_popularity: book.wiki_page_stats.sum(&:views))
  end

  private

  attr_reader :book

  def initialize_page_stats
    name, locale = InfoFetchers::Wiki::UrlParser.extract_base_name_and_locale(book.wiki_url)
    raise "Can't extract base name and locale from #{book.wiki_url}" if name.blank? || locale.blank?

    variants = InfoFetchers::Wiki::VariantsFetcher.new.fetch_variants(name, locale)
    variants.each do |locale, name|
      book.wiki_page_stats.build(locale: locale, name: name)
    end
  end

  def sync_page_stats
    book.wiki_page_stats.each do |stat|
      next if stat.views_synced_at && stat.views_synced_at > 2.months.ago

      views, views_last_month = InfoFetchers::Wiki::ViewsFetcher.new.fetch(stat.name, stat.locale,
        last_synced_at: stat.views_synced_at)
      next if views.nil? || views_last_month.nil?

      stat.views ||= 0
      stat.views += views - (stat.views_last_month || 0)
      stat.update!(views_last_month: views_last_month, views_synced_at: Time.now.utc)
    end
  end
end
