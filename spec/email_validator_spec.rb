require 'spec_helper'

describe JwtCli::EmailValidator do
  context 'valid email' do
    describe '.validate' do
      it 'returns nil' do
        expect(described_class.new.validate('example@email.com')).to be_nil
      end
    end
  end
  
  context 'invalid email' do
    describe '.validate' do
      it 'raises error' do
        expect{ described_class.new.validate('invalid@email') }.to raise_error(JwtCli::ValidationError)
      end
    end
  end
end