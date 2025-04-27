# == Schema Information
#
# Table name: books
#
#  id                   :integer          not null, primary key
#  aws_covers           :json
#  goodreads_popularity :integer
#  goodreads_rating     :float
#  goodreads_url        :string
#  original_title       :string
#  popularity           :integer          default(0)
#  title                :string           not null
#  year_published       :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  author_id            :integer          not null
#
# Indexes
#
#  index_books_on_author_id            (author_id)
#  index_books_on_title_and_author_id  (title,author_id) UNIQUE
#  index_books_on_year_published       (year_published)
#

module Admin
  class Book < ::Book
  end
end
