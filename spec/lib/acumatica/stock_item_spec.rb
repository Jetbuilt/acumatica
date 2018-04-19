RSpec.describe Acumatica::StockItem do
  let(:client) { configure_client }

  describe ".create", :vcr do
    before { client.login }
    after  { client.logout }

    subject { described_class.create }

    it "returns created stock item" do
      is_expected.to be_a(described_class)
    end
  end

  describe ".find_all", :vcr do
    before { client.login }
    after  { client.logout }

    subject(:results) { described_class.find_all(limit: 1) }

    it "returns array of stock items" do
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
