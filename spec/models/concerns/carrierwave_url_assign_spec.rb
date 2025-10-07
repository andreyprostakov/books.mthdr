require 'rails_helper'

RSpec.describe CarrierwaveUrlAssign do
  class TestModel
    include CarrierwaveUrlAssign

    def foobar=(value)
      assign_remote_url_or_data(:aws_foobar, value)
    end

    def aws_foobar=(...)
    end

    def remote_aws_foobar_url=(...)
    end
  end

  describe '#assign_remote_url_or_data' do
    subject(:call) { model.foobar = value }

    let(:model) { TestModel.new }
    let(:value) { 'https://example.com/photo.jpg' }

    context 'when the value is a URL' do
      it 'assigns as the remote URL' do
        allow(model).to receive(:remote_aws_foobar_url=)
        call
        expect(model).to have_received(:remote_aws_foobar_url=).with(value)
      end
    end

    context 'when the value is an image encoded' do
      let(:value) { 'data:image/jpeg;base64,...' }

      it 'assigns as data' do
        allow(model).to receive(:aws_foobar=)
        call
        expect(model).to have_received(:aws_foobar=).with(value)
      end
    end
  end
end
