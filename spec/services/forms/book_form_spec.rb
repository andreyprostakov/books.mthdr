# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forms::BookForm do
  let(:form) { described_class.new(book) }
  let(:book) { build(:book) }

  describe '#update' do
    subject(:call) { form.update(updates) }

    let(:updates) { { title: 'NEW_TITLE' } }

    context 'when the record is new' do
      it 'persists given changes and returns true' do
        expect { call }.to change(Book, :count).by(1)
        expect(call).to be true
        expect(form.errors).to be_empty
        expect(book.title).to eq('NEW_TITLE')
      end

      context 'with invalid params' do
        let(:updates) { { title: '' } }

        it 'exposes errors', :aggregate_failures do
          expect { call }.not_to change(Book, :count)
          expect(call).to be false
          expect(form.errors[:title]).to include('can\'t be blank')
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

        before { preexisting_tags }

        it 'assigns tags by given names' do
          expect { call }.to change(Tag, :count).by(1)

          new_tag = Tag.last
          expect(new_tag.name).to eq('tag_c')
          expect(book.reload.tags).to contain_exactly(new_tag, preexisting_tags[0], preexisting_tags[1])
        end
      end
    end

    context 'when the record is persisted' do
      let(:book) { create(:book, title: 'OLD_TITLE') }

      before { book }

      it 'persists given changes and returns true' do
        call
        expect(call).to be true
        expect(form.errors).to be_empty
        expect(book.reload.title).to eq('NEW_TITLE')
      end

      context 'with invalid params' do
        let(:updates) { { title: '' } }

        it 'exposes errors', :aggregate_failures do
          call
          expect(call).to be false
          expect(form.errors[:title]).to include('can\'t be blank')
          expect(book.reload.title).to eq('OLD_TITLE')
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

        before { book.tags = preexisting_tags.values_at(0, 2) }

        it 'assigns tags by given names' do
          expect { call }.to change(Tag, :count).by(1)

          new_tag = Tag.last
          expect(new_tag.name).to eq('tag_c')
          expect(book.reload.tags).to contain_exactly(new_tag, preexisting_tags[0], preexisting_tags[1])
        end
      end
    end
  end
end
