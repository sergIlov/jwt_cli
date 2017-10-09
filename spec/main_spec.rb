require 'spec_helper'

describe JwtCli::Main do
  describe '.process' do
    context 'when need help' do
      it 'show help' do
        allow(subject).to receive(:gets).and_return('what should i do?')
        allow(subject).to receive(:running?).and_return(true, false)
        expect(subject).to receive(:puts).with('To start JWT token generation type jwt_me')
        subject.start
      end
    end
    
    context 'when correct flow' do
      it 'passes message to session' do
        allow(subject).to receive(:gets).and_return('jwt_me', 'email')
        allow(subject).to receive(:running?).and_return(true, true, false)
        expect_any_instance_of(JwtCli::JwtMeSession).to receive(:process).with('email')
        subject.start
      end

      it 'displays session status' do
        allow(subject).to receive(:gets).and_return('jwt_me', 'email')
        allow(subject).to receive(:running?).and_return(true, false)
        allow_any_instance_of(JwtCli::JwtMeSession).to receive(:state_message).and_return('some status')
        expect(subject).to receive(:puts).with('Starting with JWT token generation.')
        expect(subject).to receive(:puts).with('some status')
        subject.start
      end
    end
  end
end