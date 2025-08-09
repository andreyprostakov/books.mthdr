class InfoFetchers::Wiki::VariantsFetcher
  PREFERRED_LANGUAGES = %w[en].freeze

  def fetch_variants(page_name, locale)
    variants = {locale => page_name}
    response = InfoFetchers::Bench.log("fetch_variants #{page_name} in #{locale}") do
      Faraday.get(
        "https://#{locale}.wikipedia.org/w/api.php?action=query&titles=#{URI.encode_uri_component(page_name)}&"\
        "prop=langlinks&format=json&lllimit=500"
      )
    end
    unless response.success?
      Rails.logger.error("Failed to fetch wiki variants for #{page_name} in #{locale}: #{response.status}")
      return variants
    end

    contents = JSON.parse(response.body)
    links = contents.dig("query", "pages").values.last["langlinks"]
    if links.blank?
      Rails.logger.error("No langlinks found for #{page_name} in #{locale}")
      Rails.logger.debug(response.body)
    else
      links.each do |langlink|
        language = langlink.fetch("lang")
        next unless language.in?(PREFERRED_LANGUAGES)

        variants[language] = langlink.fetch("*")
      end
    end

    variants
  end
end
