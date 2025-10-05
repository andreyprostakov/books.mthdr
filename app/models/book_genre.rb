# == Schema Information
#
# Table name: book_genres
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :integer          not null
#  genre_id   :integer
#
# Indexes
#
#  index_book_genres_on_book_id               (book_id)
#  index_book_genres_on_book_id_and_genre_id  (book_id,genre_id) UNIQUE
#  index_book_genres_on_genre_id              (genre_id)
#
# Foreign Keys
#
#  book_id   (book_id => books.id)
#  genre_id  (genre_id => genres.id)
#
class BookGenre < ApplicationRecord
  include HasCodifiedName

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
  ].freeze

  belongs_to :book
  belongs_to :genre

  delegate :name, to: :genre, prefix: true

  define_codified_attribute :name
end
