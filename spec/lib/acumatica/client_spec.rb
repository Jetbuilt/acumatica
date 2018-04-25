# frozen_string_literal: true

RSpec.describe Acumatica::Client do
  let(:client) do
    described_class.configure do |config|
      config.url = ENV['ACUMATICA_URL']
      config.name = ENV['ACUMATICA_USER']
      config.password = password
    end
  end

  let(:password) { ENV['ACUMATICA_PASSWORD'] }

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
end
