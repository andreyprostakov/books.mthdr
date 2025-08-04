class InfoFetchers::Wiki::VariantsFetcher
  def fetch_variants(page_name, locale)
    response = InfoFetchers::Bench.log("fetch_variants #{page_name} in #{locale}") do
      Faraday.get(
        "https://#{locale}.wikipedia.org/w/api.php?action=query&titles=#{URI.encode_uri_component(page_name)}&"\
        "prop=langlinks&format=json&lllimit=500"
      )
    end
    unless response.success?
      Rails.logger.error("Failed to fetch wiki variants for #{page_name} in #{locale}: #{response.status}")
      return {}
    end

    contents = JSON.parse(response.body)
    contents.dig("query", "pages").values.last.fetch("langlinks").each_with_object({}) do |langlink, memo|
      memo[langlink.fetch("lang")] = langlink.fetch("*")
    end
  end
end
