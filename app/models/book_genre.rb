# == Schema Information
#
# Table name: book_genres
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :integer          not null
#
# Indexes
#
#  index_book_genres_on_book_id           (book_id)
#  index_book_genres_on_book_id_and_name  (book_id,name) UNIQUE
#
# Foreign Keys
#
#  book_id  (book_id => books.id)
#
class BookGenre < ApplicationRecord
  STANDARD_GENRES = %w[
    literary

    scifi
    fantasy
    horror
    mystery
    thriller
    romance
    adventure
    humor

    biography
    history
    science
    help
    philosophy
    journalism
    travel
    reference
    art
  ]

  belongs_to :book

  validates :name, presence: true
end
