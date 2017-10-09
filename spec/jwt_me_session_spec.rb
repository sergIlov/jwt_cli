require 'spec_helper'

describe JwtCli::JwtMeSession do
  context 'just created' do
    describe '.state_message' do
      it 'expect first key' do
        expect(described_class.new.state_message).to eq 'Enter key 1'
      end
    end
    
    describe '.finished?' do
      it 'false' do
        expect(described_class.new.finished?).to be_falsey
      end
    end
  end
  
  context 'when got invalid key' do
    describe '.state_message' do
      let(:session) { described_class.new }
      before { session.process('invalid key') }
      it 'is correct' do
        expect(session.state_message).to eq 'Invalid key name! Enter key 1'
      end
    end
  end

  context 'when got invalid email' do
    describe '.state_message' do
      let(:session) { described_class.new }
      before do
        session.process('email')
        session.process('invalid@email')
      end
      
      it 'is correct' do
        expect(session.state_message).to eq 'Invalid email entered! Enter email value'
      end
    end
  end
  
  context 'when get valid data' do
    describe '.state_message' do
      let(:session) { described_class.new }
      it 'changes key number' do
        session.process('foo')
        session.process('bar')
        
        expect(session.state_message).to eq 'Enter key 2'
      end
      
      it 'use key name' do
        session.process('foo')

        expect(session.state_message).to eq 'Enter foo value'
      end
    end
  end
  
  context 'when all required fields filled' do
    let(:session) { described_class.new }
  
    before {
      session.process('email')
      session.process('valid@email.com')
      session.process('user_id')
      session.process('1')
    }
    
    describe '.state_message' do
      it 'is correct' do
        expect(session.state_message).to eq 'Any additional inputs? (yes/no)'
      end
    end
    
    context 'when no additional fields' do
      before { session.process('no') }
      
      describe '.state_message' do
        it 'is correct' do
          expect(session.state_message).to eq 'The JWT has been copied to your clipboard!'
        end
      end
      
      describe '.finished?' do
        it 'is true' do
          expect(session.finished?).to be_truthy
        end
      end
      
      it 'save token to clipboard' do
        session.process('email')
        session.process('valid@email.com')
        session.process('user_id')
        session.process('1')
        session.process('no')
        
        expect(Clipboard.paste).to eq 'eyJhbGciOiJub25lIn0.eyJlbWFpbCI6InZhbGlkQGVtYWlsLmNvbSIsInVzZXJfaWQiOiIxIn0.'
      end
    end
  end
end
