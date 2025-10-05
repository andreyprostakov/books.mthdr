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
require 'rails_helper'

RSpec.describe Tag do
  subject(:tag) { build(:tag) }

  describe '#category enum' do
    it do
      expect(tag).to define_enum_for(:category)
        .with_values(%i[other format genre location series award theme])
    end
  end

  describe 'validation' do
    subject { build(:tag) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

    it 'has a valid factory' do
      expect(build(:tag)).to be_valid
    end
  end

  it_behaves_like 'has codified name', :name do
    let(:record) { build(:tag) }
  end
end
