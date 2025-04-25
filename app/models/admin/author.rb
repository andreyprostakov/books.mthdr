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

module Admin
  class Author < Author
  end
end
