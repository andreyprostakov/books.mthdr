# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  category   :integer          default("other")
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_category  (category)
#  index_tags_on_name      (name) UNIQUE
#
class Tag < ApplicationRecord
  has_many :tag_connections, class_name: 'TagConnection', dependent: :destroy

  # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :book_tag_connections, -> { where(entity_type: Book.name) },
           class_name: 'TagConnection', inverse_of: :tag
  has_many :author_tag_connections, -> { where(entity_type: Author.name) },
           class_name: 'TagConnection', inverse_of: :tag
  # rubocop:enable Rails/HasManyOrHasOneDependent

  has_many :books, through: :book_tag_connections
  has_many :authors, through: :author_tag_connections

  enum :category, {
    other: 0,
    format: 1,
    genre: 2,
    location: 3,
    series: 4,
    award: 5,
    theme: 6
  }

  before_validation :prepare_name

  validates :name, presence: true, uniqueness: { case_sensitive: false },
                   format: { with: /\A[a-z\d_]+\z/ }
  validates :category, presence: true

  scope :with_name, ->(name) { where(name: Array(name).map { |n| normalize_name(n) }) }

  searchable do
    text :name do
      name.titleize
    end
  end

  def self.find_or_create_by_name(name, category)
    with_name(name).first ||
      create!(name: name, category: category.to_sym)
  end

  def self.normalize_name(name)
    name.strip.gsub(/\W/, '_').downcase
  end

  protected

  def prepare_name
    return if name.blank?

    self.name = self.class.normalize_name(name)
  end
end
