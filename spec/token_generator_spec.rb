require 'spec_helper'

describe JwtCli::TokenGenerator do
  describe '.generate' do
    let(:payload) { { email: 'some@email.com', user_id: '12' } }
    let(:expected_token) { 'eyJhbGciOiJub25lIn0.eyJlbWFpbCI6InNvbWVAZW1haWwuY29tIiwidXNlcl9pZCI6IjEyIn0.' }
    
    it 'creates token' do
      expect(described_class.new.generate(payload)).to eq expected_token
    end
  end
end