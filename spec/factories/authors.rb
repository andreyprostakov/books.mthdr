# frozen_string_literal: true

# == Schema Information
#
# Table name: authors
#
#  id         :integer          not null, primary key
#  fullname   :string           not null
#  reference  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  birth_year :integer
#  death_year :integer
#  aws_photos :json
#
# Indexes
#
#  index_authors_on_fullname  (fullname) UNIQUE
#

FactoryBot.define do
  factory :author, class: 'Author' do
    sequence(:fullname) { |i| "King Henry #{i}" }
  end
end
