module InfoFetchers
  module Chats
    class AuthorBooksUpdatesExpert
      INSTRUCTIONS = <<-INSTRUCTIONS.freeze
        You are a literature nerd.
        You are given a name of an author and a year.
        You need to provide information about ALL of their books and short stories published starting from that year or later (or planned to be published).
        Prefer author's bibliography in wikipedia in several languages, make sure the list is complete and up to date!
        Every line of CSV output must have format: "<book or story title in English, if available>", "<original title in original language, if available>", <year of publishing>, <source name>.
        Don't output anything else - only CSV content.
      INSTRUCTIONS

      def ask_books_list(author, year)
        chat = setup_chat
        chat.ask("#{author.fullname}, #{year}")
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
