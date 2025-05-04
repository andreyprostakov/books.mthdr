module Admin
  module BaseHelper
    def admin_timestamp(time)
      return if time.blank?

      time.strftime('%y-%m-%d %H:%M:%S')
    end

    def sortable_table_column(label, parameter)
      if params[:sort_by] == parameter
        if params[:sort_order] == 'desc'
          link_to("#{label} ↑", url_for(sort_by: parameter, sort_order: 'asc', page: 1))
        else
          link_to("#{label} ↓", url_for(sort_by: parameter, sort_order: 'desc', page: 1))
        end
      else
        link_to(label, url_for(sort_by: parameter, page: 1))
      end
    end

    def authors_link
      link_to 'Authors', admin_authors_path
    end

    def author_link(author)
      link_to author.fullname, admin_author_path(author)
    end

    def books_link
      link_to 'Books', admin_books_path
    end

    def book_link(book)
      link_to "\"#{book.title}\"", admin_book_path(book)
    end

    def author_books_link(author)
      link_to 'Books', admin_author_books_path(author)
    end

    def ai_chats_link
      link_to 'AI Chats', admin_ai_chats_path
    end

    def ai_chat_link(chat)
      link_to "Chat ##{chat.id}", admin_ai_chat_path(chat)
    end
  end
end
