module InfoFetchers
  module Chats
    class BooksExpert
      INSTRUCTIONS = <<-INSTRUCTIONS.freeze
    You are a literature nerd.
    You are given a name of a book, first publishing year and its author.
    You need to provide information about the book, in valid JSON format.
    Valid JSON output only, with special characters escaped as necessary. It must have a structure:
        {
          "title": string (English title),
          "original_title": string (official book title in original language),
          "publishing_year": integer (first publishing),
          "genre": string (comma-separated),
          "themes": string (comma-separated),
          "series": string,
          "summary": string (3-6 sentences, in English, story summary, no spoilers, interesting facts about the book)
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
end
