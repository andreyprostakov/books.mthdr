module InfoFetchers
  module Chats
    class AuthorBooksListExpert
      INSTRUCTIONS = <<-INSTRUCTIONS.freeze
        You are a meticulous bibliographer.

        Your goal: compile a COMPLETE list of ALL published works (novels + single short stories, no collections) by the given author.

        Process:
        1. Confirm the author’s full name and active years.
        2. Search the web for their bibliography in at least English language.
        3. Display the URLs you found BEFORE listing works.
        4. From each source, copy all titles EXACTLY as they appear, with their original publication year.
        5. Merge all titles into one deduplicated list.
        6. For each title, if the wikipedia's bibliography page contains a clickable Wikipedia link to that work, collect that URL.
        7. Exclude story collections, anthologies, and omnibuses.
        8. JSON output only. It must have structure:
          { "notes": "<warnings, if any>",
            "works": [[
              "<title>" (string, English, if ever published in English),
              "<original_title>" (in original language, null if originally in English),
              <publishing_year> (integer),
              "<wikipedia_url>" (string, null if not found)
            ], [etc...]]
          }

        Rules:
        - Do not omit any obscure or early works.
        - Do not skip unpublished works that were released posthumously.
        - If a title appears in multiple languages, list the original title first.
        - Do not summarize or group works — list each as a separate row.
        - Only after giving the full list, note any works where the year or source could not be found.
        - If you reach the token limit, stop and say: "TRUNCATED – CONTINUE IN NEXT MESSAGE".
      INSTRUCTIONS

      OUTPUT_INSTRUCTIONS = <<-INSTRUCTIONS.freeze
        JSON output only. It must have structure:
          { "notes": "<notes about the author>",
            "works": [[
              "<title>" (string, English, if ever published in English),
              "<original_title>" (in original language, null if originally in English),
              <publishing_year> (integer)
            ], [etc...]]
          }
      INSTRUCTIONS

      def ask_books_list(author)
        chat = setup_chat
        response = chat.ask("Author: #{author.fullname}")
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
