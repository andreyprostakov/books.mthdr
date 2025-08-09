class InfoFetchers::Wiki::UrlParser
  def self.extract_base_name_and_locale(url)
    locale = url.match(%r{^https?://(.*)\.wikipedia\.org/})&.[](1)
    name = url[/wiki\/([^\/]*)$/, 1]
    name = CGI.unescape(name) if name.present?
    [name, locale]
  end
end
