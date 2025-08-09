module InfoFetchers
  module Wiki
    class VariantsFetcher
      PREFERRED_LANGUAGES = %w[en].freeze

      def fetch_variants(page_name, locale)
        variants = { locale => page_name }
        contents = request_data(page_name, locale)
        return variants if contents.blank?

        extract_links_from_response(contents).each do |langlink|
          language = langlink.fetch('lang')
          next unless language.in?(PREFERRED_LANGUAGES)

          variants[language] = langlink.fetch('*')
        end

        variants
      end

      private

      def request_data(page_name, locale)
        response = send_call(page_name, locale)
        if response.success?
          JSON.parse(response.body)
        else
          Rails.logger.error("Failed to fetch wiki variants for #{page_name} in #{locale}: #{response.status}")
          nil
        end
      end

      def send_call(page_name, locale)
        url = "https://#{locale}.wikipedia.org/w/api.php?action=query&titles=#{URI.encode_uri_component(page_name)}&" \
              'prop=langlinks&format=json&lllimit=500'
        InfoFetchers::Bench.log("fetch_variants #{page_name} in #{locale}") do
          Faraday.get(url)
        end
      end

      def extract_links_from_response(contents)
        links = contents.dig('query', 'pages').values.last['langlinks']
        if links.blank?
          Rails.logger.error("No langlinks found for #{page_name} in #{locale}")
          Rails.logger.debug(contents)
          []
        end
        links
      end
    end
  end
end
