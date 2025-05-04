module Admin
  module LinksHelper
    def external_link_to(text, url, **options)
      link_to text, url, options.reverse_merge(target: '_blank')
    end

    def display_link_to(text, url, **options)
      link_to text, url, options.reverse_merge(target: '_blank', class: 'btn btn-link display-link')
    end

    def admin_link_to(text, url, **)
      link_to(text, url, **)
    end

    def admin_buttonly_link_to(text, url, **options)
      admin_link_to text, url, **options.reverse_merge(class: 'btn btn-link')
    end

    def admin_nav_authors_link
      link_to 'Authors', admin_authors_path
    end

    def admin_nav_author_link(author)
      link_to author.fullname, admin_author_path(author)
    end

    def admin_nav_books_link
      link_to 'Books', admin_books_path
    end

    def admin_nav_book_link(book)
      link_to "\"#{book.title}\"", admin_book_path(book)
    end

    def admin_nav_ai_chats_link
      link_to 'AI Chats', admin_ai_chats_path
    end

    def admin_nav_ai_chat_link(chat)
      link_to "Chat ##{chat.id}", admin_ai_chat_path(chat)
    end

    def admin_nav_tags_link
      link_to 'Tags', admin_tags_path
    end

    def admin_nav_tag_link(tag)
      link_to tag.name, admin_tag_path(tag)
    end

    def author_display_path(author)
      "/authors/#{author.id}"
    end

    def book_display_path(book)
      "/books/#{book.id}"
    end

    def tag_display_path(tag)
      "/tags/#{tag.id}"
    end
  end
end
