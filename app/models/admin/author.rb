# == Schema Information
#
# Table name: authors
#
#  id                :integer          not null, primary key
#  aws_photos        :json
#  birth_year        :integer
#  cover_type        :string
#  death_year        :integer
#  fullname          :string           not null
#  original_fullname :string
#  reference         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_authors_on_fullname  (fullname) UNIQUE
#

module Admin
  class Author < ::Author
    scope :order_by_fullname, -> { order(:fullname) }
  end
end
