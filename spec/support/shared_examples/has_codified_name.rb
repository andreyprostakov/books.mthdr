shared_examples 'has codified name' do |attribute|
  describe "codified #{attribute}" do
    it 'is normalized upon validation' do
      record.send("#{attribute}=", "   NAME ,1 \n")
      expect { record.valid? }.to change(record, attribute).from("   NAME ,1 \n").to('name__1')
    end
  end

  describe '.normalize_name_value' do
    it 'strips whitespace and special characters and downcases the result' do
      expect(described_class.normalize_name_value("   NAME ,1 \n")).to eq('name__1')
    end
  end
end
