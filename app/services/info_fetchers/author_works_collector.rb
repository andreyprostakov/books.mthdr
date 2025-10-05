module InfoFetchers
  class AuthorWorksCollector
    def initialize(author)
      @author = author
    end

    def collect
      return if author.synced_at.nil? || author.synced_at > 1.year.ago
      return if author.death_year.nil?
    end
  end
end
