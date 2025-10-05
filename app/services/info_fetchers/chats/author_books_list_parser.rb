module InfoFetchers
  module Chats
    class AuthorBooksListParser
      INSTRUCTIONS = <<-INSTRUCTIONS.freeze
        You are a books list parser.

        Your goal: read the given list of works and output it in JSON format.
        JSON output only. It must have structure:
          [[
            "<title>" (string, English),
            <publishing_year> (integer),
            "<type>" (string, novel, short_story, etc)
          ], [etc...]]
      INSTRUCTIONS

      def parse_books_list(text)
        safe_wrap do
          chat = setup_chat
          response = chat.ask(text)
          data = JSON.parse(response.content)
          data.map do |item|
            title, year, type = item
            { title: title, year: year, type: type }
          end
        end
      end

      private

      def safe_wrap
        yield
      rescue StandardError => e
        Rails.logger.error("Error parsing books list: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
        []
      end

      def setup_chat
        Ai::Chat.start.tap do |chat|
          chat.with_instructions(INSTRUCTIONS)
        end
      end
    end
  end
end
