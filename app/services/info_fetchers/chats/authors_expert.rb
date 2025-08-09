module InfoFetchers
  module Chats
    class AuthorsExpert
      INSTRUCTIONS = <<-INSTRUCTIONS.freeze
    You are an expert in literature.
    You are given a name of an author.
    You need to provide information about author and each book written by them, in JSON format.
    JSON output only. It must have a structure:
        {"author":
          {"fullname": string (full name),
          "original_name": string,
          "countries": string (comma-separated),
          "birth_year": integer,
          "death_year": integer
        },
        "books": [
          {
            "title": string (English, if ever published in English),
            "original_title": string,
            "publishing_year": integer
          }
        ]}.
      INSTRUCTIONS

      def ask_books_list(fullname)
        chat = setup_chat
        JSON.parse(chat.ask(fullname).content)
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
