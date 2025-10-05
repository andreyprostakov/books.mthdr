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

    def admin_nav_crumbs(*crumbs)
      content_for :title, safe_join(crumbs, ' > ')
    end

    def admin_nav_authors_link
      link_to 'Authors', admin_authors_path
    end

    def admin_nav_author_link(author)
      link_to truncate_crumb(author.fullname, length: 30), admin_author_path(author)
    end

    def admin_nav_books_link
      link_to 'Books', admin_books_path
    end

    def admin_nav_book_link(book)
      link_to "\"#{truncate_crumb(book.title, length: 40)}\"", admin_book_path(book)
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
      link_to truncate_crumb(tag.name), admin_tag_path(tag)
    end

    def truncate_crumb(crumb, length: 20)
      truncate(crumb, length: length, separator: ' ', escape: false)
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

    def admin_nav_cover_designs_link
      link_to 'Cover Designs', admin_covers_cover_designs_path
    end

    def admin_nav_cover_design_link(design)
      "\"#{truncate_crumb(design.name)}\""
    end

    def admin_nav_genres_link
      link_to 'Genres', admin_genres_path
    end

    def admin_nav_genre_link(genre)
      "\"#{truncate_crumb(genre.name)}\""
    end
  end
end
