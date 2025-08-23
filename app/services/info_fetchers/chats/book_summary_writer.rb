module InfoFetchers
  module Chats
    class BookSummaryWriter
      INSTRUCTIONS = <<~INSTRUCTIONS
        give me attributes and a summary of a given book.
        steps:
        1. search web resources for descriptions or reviews of the book;
        2. collect a plot summary, genre and themes based on each resource information, stop when you collect 3 valid summaries;
        3. prepare output of the collected summaries and their sources.
        4. print JSON output only.
        rules:
        1. summary text should contain 50 to 150 words;
        2. summary should be about the book and its contents, it should not describe themes;
        3. output should be in English;
        4. valid genres are: literary, scifi, fantasy, horror, mystery, thriller, romance, adventure, humor, biography, history, science, help, philosophy, journalism, travel, reference, art;
        5. output should be of format: [{"summary":"SOME_SUMMARY","themes":"MAIN_THEME1,MAIN_THEME2","genre":"GENRE1,GENRE2","src":"SOURCE_NAME"}].
      INSTRUCTIONS

      def ask(book_title, year, author)
        chat = setup_chat
        answer = chat.ask("\"#{book_title}\" (#{year}) by #{author.fullname}").content
        JSON.parse(answer).map(&:deep_symbolize_keys)
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
