module AiClients
  class BookInfoFetcher
    INSTRUCTIONS = <<-INSTRUCTIONS.freeze
      You are an expert in literature.
      You are given a name of a book, first publishing year and its author.
      You need to provide information about the book, in valid JSON format.
      JSON output only. It must have a structure:
          {
            "title": string (English title),
            "original_title": string (official book title in original language),
            "publishing_year": integer (first publishing),
            "goodreads_url": string (if exists),
            "wiki_url": string (if exists),
            "genre": string (comma-separated),
            "themes": string (comma-separated),
            "series": string,
            "summary": string (2-3 sentences; in English; with no mention of book title or publishing year of author name; plot and vibes, no spoilers; flavored according to book's genre)
          }
    INSTRUCTIONS

    def ask_book_info(book_title, year, author)
      chat = setup_chat
      JSON.parse(chat.ask("\"#{book_title}\" (#{year}) by #{author.fullname}").content)
    end

    private

    def setup_chat
      Ai::Chat.start.tap do |chat|
        chat.with_instructions(INSTRUCTIONS)
      end
    end
  end
end
