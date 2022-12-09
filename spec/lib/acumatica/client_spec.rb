# frozen_string_literal: true

RSpec.describe Acumatica::Client do
  let(:client) do
    described_class.configure do |config|
      config.url  = ENV.fetch('ACUMATICA_URL')
      config.name = ENV.fetch('ACUMATICA_USER')
      config.password = password
    end
  end

  let(:password) { ENV.fetch('ACUMATICA_PASSWORD') }

  describe '#login', :vcr do
    subject(:request) { client.login }

    context 'when login succeeds' do
      it { is_expected.to be(true) }
    end

    context 'when login fails' do
      let(:password) { nil }

      it 'raises an error' do
        expect { request }.to raise_error(Acumatica::InternalServerError, /Invalid credentials/)
      end
    end
  end

  describe '#logout', :vcr do
    subject { client.logout }

    it { is_expected.to be(true) }
  end

  describe "#session" do
    subject(:session) do
      client.session do
        block_return
      end
    end

    before do
      allow(client).to receive(:login)
      allow(client).to receive(:logout)
    end

    let(:block_return) { "hello!" }

    it 'returns the return value of the block passed', :aggregate_failures do
      expect(session).to eq(block_return)
      expect(client).to have_received(:login)
      expect(client).to have_received(:logout)
    end
  end
end
