require 'rails_helper'

RSpec.describe Genre do
  subject { build(:genre) }

  describe 'associations' do
    it { is_expected.to belong_to(:cover_design).class_name(CoverDesign.name).optional }
    it { is_expected.to have_many(:book_genres).class_name(BookGenre.name) }
    it { is_expected.to have_many(:books).class_name(Book.name).through(:book_genres) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

    it 'has a valid factory' do
      expect(build(:genre)).to be_valid
    end
  end

  it_behaves_like 'has codified name', :name do
    let(:record) { build(:genre) }
  end
end
