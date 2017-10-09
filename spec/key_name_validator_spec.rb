require 'spec_helper'

describe JwtCli::KeyNameValidator do
  context 'valid key' do
    describe '.validate' do
      it 'returns nil' do
        expect(described_class.new.validate('some_key')).to be_nil
      end
    end
  end
  
  context 'key contains special chars' do
    describe '.validate' do
      it 'raises error' do
        expect{ described_class.new.validate('!@1') }.to raise_error(JwtCli::ValidationError)
      end
    end
  end
  
  context 'key is empty' do
    describe '.validate' do
      it 'raises error' do
        expect{ described_class.new.validate('') }.to raise_error(JwtCli::ValidationError)
      end
    end
  end
end