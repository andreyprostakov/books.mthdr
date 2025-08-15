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
require 'rails_helper'

RSpec.describe BookGenre, type: :model do
  subject { build(:book_genre) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to belong_to(:book).required }
  end
end
