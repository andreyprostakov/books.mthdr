module InfoFetchers
  module Chats
    class BookSummaryWriter
      INSTRUCTIONS = <<~INSTRUCTIONS
        give me attributes and a summary of a given book.
        steps:
        1. search web resources for long detailed descriptions of the book;
        2. from two resources, collect separately:
        2.1. a short exposition of the story, including main characters, with key events and without heavy spoilers, 200..400 words;
        2.2. source name;
        2.3. genre names (examples: literary, scifi, fantasy, horror, mystery, thriller, romance, adventure, humor, biography, history, science, help, philosophy, journalism, travel, reference, art);
        2.4. themes.
        3. prepare output of the collected pieces and their sources;
        4. print JSON output only.
        rules:
        1. all output should be in English;
        2. output should be of format: [{"summary":"SUMMARY","themes":"MAIN_THEME1,MAIN_THEME2","genre":"GENRE1,GENRE2","src":"SOURCE_NAME"}].
      INSTRUCTIONS
      INSTRUCTIONS2 = <<~INSTRUCTIONS
        give me attributes and a summary of a given book.
        steps:
        1. search web resources for long detailed descriptions of the book;
        2. from up to two resources, collect separately:
        2.1. a short exposition of the story, including main characters, with key events and without heavy spoilers, 200..400 words, do not quote the prompt!;
        2.2. genre names (examples: literary, scifi, fantasy, horror, mystery, thriller, romance, adventure, humor, biography, history, science, help, philosophy, journalism, travel, reference, art);
        2.3. themes;
        2.4. source name.
        3. prepare output of the collected pieces and their sources;
        4. print JSON output only.
        rules:
        1. all output should be in English;
        2. output should be of format: [{"summary":"SOME_SUMMARY","themes":"MAIN_THEME1,MAIN_THEME2","genre":"GENRE1,GENRE2","src":"SOURCE_NAME"}].
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
