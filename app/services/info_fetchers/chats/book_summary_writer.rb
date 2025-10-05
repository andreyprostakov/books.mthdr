module InfoFetchers
  module Chats
    class BookSummaryWriter
      INSTRUCTIONS = <<~INSTRUCTIONS.freeze
        give me attributes and a summary of a given book.
        steps:
        1. search web resources for long detailed descriptions of the book;
        2. from two resources, collect separately:
        2.1. a short exposition of the story, including main characters, with key events and without heavy spoilers, 200..400 words;
        2.2. source name;
        2.3. genre name (one of: <GENRES>);
        2.4. themes.
        3. prepare output of the collected pieces and their sources;
        4. print JSON output only.
        rules:
        1. all output should be in English;
        2. output should be of format: [{"summary":"SUMMARY","themes":"MAIN_THEME1,MAIN_THEME2","genre":"GENRE1","src":"SOURCE_NAME"}].
      INSTRUCTIONS

      def ask(book_title, year, author)
        chat = setup_chat
        answer = chat.ask("\"#{book_title}\" (#{year}) by #{author.fullname}").content
        JSON.parse(answer).map(&:deep_symbolize_keys)
      end

      private

      def setup_chat
        Ai::Chat.start.tap do |chat|
          chat.with_instructions(INSTRUCTIONS.gsub('<GENRES>', Genre.pluck(:name).join(',')))
        end
      end
    end
  end
end
