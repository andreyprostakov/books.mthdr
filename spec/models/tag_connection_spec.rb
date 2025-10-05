require 'rails_helper'

RSpec.describe TagConnection do
  subject(:tag_connection) { build(:tag_connection) }

  describe 'associations' do
    it { is_expected.to belong_to(:tag).class_name(Tag.name).required }
    it { is_expected.to belong_to(:entity) }
  end
end
