# == Schema Information
#
# Table name: cover_designs
#
#  id                :integer          not null, primary key
#  author_name_color :string           not null
#  author_name_font  :string           not null
#  cover_image       :string           not null
#  name              :string           not null
#  title_color       :string           not null
#  title_font        :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class CoverDesign < ApplicationRecord
  include HasCodifiedName

  FONTS = %w[
    montserrat
    bebas_neue
    playfair_display
    libre_baskerville
    amarante
    cinzel
    iceberg
    special_elite
  ].freeze

  COLORS = %w[
    white
    black
    firebrick
    antiquewhite
  ].freeze

  COVER_IMAGES = %w[
    default
    red_scratches
    brown_wave
    gray_marks
    brown_skin
    dark_red
    wood_plank
    water_rocks
    modern
    fire
    chalk_board
    hard_blue_texture
    blurry_glass
    parchment
  ].freeze

  validates :name, presence: true
  validates :title_color, presence: true
  validates :title_font, presence: true
  validates :author_name_color, presence: true
  validates :author_name_font, presence: true
  validates :cover_image, presence: true

  define_codified_attribute :name
  define_codified_attribute :title_font
  define_codified_attribute :author_name_font

  def self.default
    find_by(name: 'default')
  end
end
