module InfoFetchers
  module Wiki
    class ViewsFetcher
      DEFAULT_PERIOD = 1.year
      MIN_PERIOD = 2.months

      def fetch(page_name, locale, last_synced_at: nil)
        start = last_synced_at || DEFAULT_PERIOD.ago
        contents = request_data(page_name, locale, start: [start, MIN_PERIOD.ago].min)
        return if contents.blank?

        items = select_relevant_items(contents, start: start)
        total_views = items.pluck('views').sum
        [total_views, items.last&.dig('views') || 0]
      end

      private

      def request_data(page_name, locale, start:)
        response = send_call(page_name, locale, start:)
        if response.success?
          JSON.parse(response.body)
        else
          Rails.logger.error("Failed to fetch wiki views for #{page_name} in #{locale}: #{response.status}")
          nil
        end
      end

      def send_call(page_name, locale, start:)
        url = "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/#{locale}.wikipedia.org/" \
              "all-access/user/#{URI.encode_uri_component(page_name)}/" \
              "monthly/#{start.strftime('%Y%m%d')}/#{Date.current.strftime('%Y%m%d')}"
        InfoFetchers::Bench.log("fetch_locale #{page_name} in #{locale}") do
          Faraday.get(url)
        end
      end

      def select_relevant_items(response_data, start:)
        min_timestamp = start.beginning_of_month.strftime('%Y%m%d')
        response_data.fetch('items').reject do |item|
          item['timestamp'] < min_timestamp
        end
      end
    end
  end
end
