# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                   :integer          not null, primary key
#  aws_covers           :json
#  goodreads_popularity :integer
#  goodreads_rating     :float
#  goodreads_url        :string
#  literary_form        :string           default("novel"), not null
#  original_title       :string
#  popularity           :integer          default(0)
#  summary              :text
#  title                :string           not null
#  wiki_popularity      :integer          default(0)
#  wiki_url             :string
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
FactoryBot.define do
  factory :book, class: 'Book' do
    sequence(:title) { |i| "Book #{i}" }
    author factory: %i[author], strategy: :create
    year_published { rand(1992..2021) }
  end
end
