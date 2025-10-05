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
require 'rails_helper'

RSpec.describe BookGenre, type: :model do
  subject { build(:book_genre) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to belong_to(:book).required }
  end
end
