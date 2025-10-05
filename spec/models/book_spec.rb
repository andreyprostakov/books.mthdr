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
#  summary_src          :string
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
require 'rails_helper'

RSpec.describe Book do
  it { is_expected.to belong_to(:author).class_name(Author.name).required(false) }
  it { is_expected.to have_many(:tag_connections).class_name(TagConnection.name) }
  it { is_expected.to have_many(:tags).class_name(Tag.name).through(:tag_connections) }
  it { is_expected.to have_many(:wiki_page_stats).class_name(WikiPageStat.name) }

  describe 'validation' do
    subject { build(:book) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:author_id) }
    it { is_expected.to validate_presence_of(:author_id) }
    it { is_expected.to validate_presence_of(:year_published) }
    it { is_expected.to validate_numericality_of(:year_published).only_integer }
    it { is_expected.to validate_numericality_of(:wiki_popularity).only_integer.is_greater_than_or_equal_to(0) }

    it 'has a valid factory' do
      expect(build(:book)).to be_valid
    end
  end

  describe 'before validation' do
    describe '#title' do
      it 'is stripped' do
        book = build_stubbed(:book, title: "   TITLE  \n")
        expect { book.valid? }.to change(book, :title).to('TITLE')
      end
    end
  end

  describe '#tag_ids' do
    subject(:result) { book.tag_ids }

    let(:book) { build(:book, tags: tags) }
    let(:tags) { create_list(:tag, 2) }

    it 'returns list of associated IDs' do
      expect(result).to match_array(tags.map(&:id))
    end
  end
end
