require 'rails_helper'

RSpec.describe Admin::BaseHelper do
  describe '#admin_timestamp' do
    subject(:result) { helper.admin_timestamp(time) }

    let(:time) { current_time - 3.months + 1.minute }
    let(:current_time) { Time.parse('2025-07-01 12:13:14') }

    around do |example|
      Timecop.freeze(current_time) { example.run }
    end

    context 'when time is newer than 3 months ago' do
      it 'returns a formatted date' do
        expect(result).to eq('Apr 01, 12:14')
      end
    end

    context 'when time is older than 3 months ago' do
      let(:time) { current_time - 3.months - 1.minute }

      it 'returns a formatted datetime' do
        expect(result).to eq('2025-04-01')
      end
    end

    context 'when time is blank' do
      let(:time) { nil }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end
  end
end
