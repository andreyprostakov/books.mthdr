class InfoFetchers::Wiki::ViewsFetcher
  DEFAULT_PERIOD = 1.year
  MIN_PERIOD = 2.months

  def fetch(page_name, locale, last_synced_at: nil)
    start = last_synced_at || DEFAULT_PERIOD.ago
    queried_start = [start, MIN_PERIOD.ago].min
    response = InfoFetchers::Bench.log("fetch_locale #{page_name} in #{locale}") do
      Faraday.get(
        "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/#{locale}.wikipedia.org/"\
        "all-access/user/#{URI.encode_uri_component(page_name)}/"\
        "monthly/#{queried_start.strftime("%Y%m%d")}/#{Date.current.strftime("%Y%m%d")}"
      )
    end
    unless response.success?
      Rails.logger.error("Failed to fetch wiki views for #{page_name} in #{locale}: #{response.status}")
      return
    end

    contents = JSON.parse(response.body)
    min_timestamp = start.beginning_of_month.strftime("%Y%m%d")
    items = contents.fetch("items").reject do |item|
      item["timestamp"] < min_timestamp
    end
    total_views = items.map {_1["views"]}.sum
    [total_views, items.last&.dig("views") || 0]
  end
end
