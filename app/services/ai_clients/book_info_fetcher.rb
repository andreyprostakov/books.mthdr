module AiClients
  class BookInfoFetcher
    INSTRUCTIONS = <<-INSTRUCTIONS.freeze
      You are an expert in literature.
      You are given a name of a book and its author.
      You need to provide information about the book, in valid JSON format.
      JSON output only. It must have a structure:
          {
            "title": string (English, if ever published in English),
            "original_title": string,
            "publishing_year": integer (first publishing),
            "goodreads_url": string,
            "wiki_url": string,
            "genre": string (comma-separated),
            "themes": string (comma-separated),
            "series": string,
            "summary": string (80-words-or-so; in English; with no mention of book title or publishing year of author name; plot and vibes, no spoilers; flavored according to book's genre)
          }
    INSTRUCTIONS

    def ask_book_info(book_title, author)
      chat = setup_chat
      JSON.parse(chat.ask("\"#{book_title}\" by #{author.fullname}").content)
    end

    private

    def setup_chat
      Ai::Chat.start.tap do |chat|
        chat.with_instructions(INSTRUCTIONS)
      end
    end
  end
end
