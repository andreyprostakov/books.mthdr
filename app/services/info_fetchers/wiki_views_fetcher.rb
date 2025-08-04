class InfoFetchers::WikiViewsFetcher
  DEFAULT_LOCALE = "en"

  def fetch_locale(article_name, locale = DEFAULT_LOCALE)
    response = benchmark("fetch_locale #{article_name} in #{locale}") do
      Faraday.get(
        "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/#{locale}.wikipedia.org/"\
        "all-access/user/#{URI.encode_uri_component(article_name)}/"\
        "monthly/#{1.year.ago.strftime("%Y%m%d")}/#{Date.current.strftime("%Y%m%d")}"
      )
    end
    unless response.success?
      Rails.logger.error("Failed to fetch wiki views for #{article_name} in #{locale}: #{response.status}")
      return 0
    end

    contents = JSON.parse(response.body)
    contents.fetch("items").map {_1["views"]}.sum
  end

  def fetch_total(article_name, locale = DEFAULT_LOCALE)
    variants = {locale => article_name}.merge(fetch_variants(article_name, locale))
    variants.map {|locale, name| [locale, name, fetch_locale(name, locale)]}.sum(&:last)
  end

  def fetch_variants(article_name, locale = DEFAULT_LOCALE)
    response = benchmark("fetch_variants #{article_name} in #{locale}") do
      Faraday.get(
        "https://#{locale}.wikipedia.org/w/api.php?action=query&titles=#{URI.encode_uri_component(article_name)}&"\
        "prop=langlinks&format=json&lllimit=500"
      )
    end
    unless response.success?
      Rails.logger.error("Failed to fetch wiki variants for #{article_name} in #{locale}: #{response.status}")
      return []
    end

    contents = JSON.parse(response.body)
    contents.dig("query", "pages").values.last.fetch("langlinks").each_with_object({}) do |langlink, memo|
      memo[langlink.fetch("lang")] = langlink.fetch("*")
    end
  end

  private

  def benchmark(action, &block)
    result = nil
    time = Benchmark.realtime do
      result = block.call
    end
    Rails.logger.info("[#{Time.current.utc.to_fs(:number)}] #{action} in #{time.round(3)}s")
    result
  end
end
