# frozen_string_literal: true

# == Schema Information
#
# Table name: authors
#
#  id                :integer          not null, primary key
#  aws_photos        :json
#  birth_year        :integer
#  death_year        :integer
#  fullname          :string           not null
#  original_fullname :string
#  reference         :string
#  synced_at         :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_authors_on_fullname  (fullname) UNIQUE
#

class Author < ApplicationRecord
  include CarrierwaveUrlAssign

  has_many :books, class_name: 'Book', inverse_of: :author, dependent: :restrict_with_error
  has_many :tag_connections, class_name: 'TagConnection', as: :entity, dependent: :destroy
  has_many :tags, through: :tag_connections, class_name: 'Tag'

  mount_base64_uploader :aws_photos, Uploaders::AwsAuthorPhotoUploader

  before_validation :strip_name

  validates :fullname, presence: true, uniqueness: true
  validates :birth_year, numericality: { only_integer: true, allow_nil: true }
  validates :death_year, numericality: { only_integer: true, allow_nil: true }

  def tag_ids
    tag_connections.map(&:tag_id)
  end

  def popularity
    books.sum(:popularity)
  end

  def photo_thumb_url
    aws_photos.url(:thumb)
  end

  def photo_card_url
    aws_photos.url(:card)
  end

  def photo_url
    aws_photos.url
  end

  def photo_url=(value)
    assign_remote_url_or_data(:aws_photos, value)
  end

  protected

  def strip_name
    return if fullname.blank?

    fullname.strip!
  end
end
