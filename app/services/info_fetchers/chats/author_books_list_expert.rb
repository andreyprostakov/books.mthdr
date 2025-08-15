module InfoFetchers
  module Chats
    class AuthorBooksListExpert
      INSTRUCTIONS = <<-INSTRUCTIONS.freeze
        You are a literature nerd.
        You are given a name of an author.
        You need to provide information about ALL of their published books and short stories.
        Prefer author's bibliography in wikipedia in several languages, make sure the list is complete and up to date!
        Every line of CSV output must have format: "<book or story title in English, if available>", "<original title in original language, if available>", <year of publishing>, <source name>.
        Valid CSV output only! Don't output anything else.
      INSTRUCTIONS

      def ask_books_list(author)
        chat = setup_chat
        response = chat.ask(author.fullname)
        response.content
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
