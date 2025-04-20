# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forms::BooksBatchForm do
  let(:form) { described_class.new(books) }
  let(:books) { [create(:book, title: 'TITLE_A'), create(:book, title: 'TITLE_B')] }

  describe '#update' do
    subject(:call) { form.update(updates) }

    let(:updates) { { title: 'NEW_TITLE' } }

    before { books }

    it 'persists given changes and returns true' do
      call
      expect(call).to be true
      expect(form.errors).to be_empty

      titles = books.map { |book| book.reload.title }
      expect(titles).to match_array %w[NEW_TITLE NEW_TITLE]
    end

    context 'with invalid params' do
      let(:updates) { { title: '' } }

      it 'exposes errors', :aggregate_failures do
        call
        expect(call).to be false
        expect(form.errors[:title]).to include('can\'t be blank')

        titles = books.map { |book| book.reload.title }
        expect(titles).to match_array %w[TITLE_A TITLE_B]
      end
    end

    context 'when params include tag_names' do
      let(:updates) { { tag_names: %w[TAG_A TAG_B TAG_C] } }
      let(:preexisting_tags) do
        [
          create(:tag, name: 'TAG_A'),
          create(:tag, name: 'TAG_B'),
          create(:tag, name: 'TAG_D')
        ]
      end

      before { books[0].tags = preexisting_tags.values_at(0, 2) }

      it 'assigns tags by given names' do
        expect { call }.to change(Tag, :count).by(1)

        new_tag = Tag.last
        expect(new_tag.name).to eq('TAG_C')
        expect(books[0].reload.tags).to match_array(preexisting_tags + [new_tag])
      end

      context 'when validation fails' do
        let(:updates) { super().merge(title: '', tag_names: ['TAG_A', 'TAG_C', 'TAG G']) }

        it 'reverts all changes to Tag', :aggregate_failures do
          expect { call }.not_to change(Tag, :count)
          expect(call).to be false
          expect(form.errors[:tags]).to include('name allows only alphanums and dashes')
        end
      end
    end
  end
end
