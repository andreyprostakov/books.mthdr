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
class Book < ApplicationRecord
  include CarrierwaveUrlAssign

  belongs_to :author, class_name: 'Author', optional: true
  has_many :tag_connections, class_name: 'TagConnection', as: :entity, dependent: :destroy
  has_many :tags, through: :tag_connections, class_name: 'Tag'

  mount_base64_uploader :aws_covers, Uploaders::AwsBookCoverUploader

  validates :title, presence: true, uniqueness: { scope: :author_id }
  validates :author_id, presence: true
  validates :year_published, presence: true, numericality: { only_integer: true, greater_than: 0 }

  before_validation :strip_title
  before_validation :calculate_popularity
  after_commit :update_ranking

  scope :with_tags, lambda { |tag_ids|
    includes(:tags).references(:tags).where(tags: { id: Array(tag_ids) })
  }

  searchable do
    text :title
  end

  def tag_ids
    tag_connections.map(&:tag_id)
  end

  def cover_thumb_url
    aws_covers.url(:thumb)
  end

  def cover_url
    aws_covers.url
  end

  def cover_url=(value)
    assign_remote_url_or_data(:aws_covers, value)
  end

  protected

  def strip_title
    return if title.blank?

    title.strip!
  end

  def calculate_popularity
    return if [goodreads_rating, goodreads_popularity].any?(&:blank?)

    self.popularity = (goodreads_rating * goodreads_popularity).floor
  end

  def update_ranking
    return unless saved_change_to_attribute?(:popularity)

    Ranking::BooksRanker.update(self)
  end
end
