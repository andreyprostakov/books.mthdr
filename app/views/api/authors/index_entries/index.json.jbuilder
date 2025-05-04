# frozen_string_literal: true

counts_by_author = Book.group(:author_id).count

json.list do
  json.partial! 'api/authors/index_entries/author', collection: @authors, as: :author,
                                                    counts_by_author: counts_by_author
end
json.total @count
