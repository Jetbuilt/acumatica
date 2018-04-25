require 'support/client'

RSpec.shared_examples "acumatica resource" do |valid_params|
  let(:client) { configure_client }

  describe ".create", :vcr do
    before { client.login }
    after  { client.logout }

    subject(:request) { described_class.create(params) }

    context 'when request succeeds' do
      let(:params) { valid_params }

      it "returns created resource" do
        is_expected.to be_a(described_class)
      end
    end

    context 'when request fails' do
      let(:params) { nil }

      it 'raises an error' do
        expect { request }.to raise_error(Acumatica::BadRequest)
      end
    end
  end

  describe ".find_all", :vcr do
    before { client.login }
    after  { client.logout }

    subject(:results) { described_class.find_all(limit: 1) }

    it "returns array of resources" do
      expect(results).to all(be_a(described_class))
    end
  end

  describe '.new' do
    subject(:resource) do
      described_class.new(
        "ItemStatus" => { "value" => "active" },
        "Attributes" => [
          { "AttributeID" => { "value" => "Manufacturer" }, "Value" => { "value" => "ACME" } },
          { "AttributeID" => { "value" => "WHAT DOES THE FOX SAY" }, "Value" => { "value" => "?" } }
        ]
      )
    end

    it "converts param keys to ruby style methods" do
      expect(resource.item_status).to eql("active")
    end

    it "converts attributes to ruby style methods on the resource" do
      expect(resource.manufacturer).to eql("ACME")
    end

    it "handles spaces and uppercase well in attribute id names" do
      expect(resource.what_does_the_fox_say).to eql("?")
    end
  end
end
