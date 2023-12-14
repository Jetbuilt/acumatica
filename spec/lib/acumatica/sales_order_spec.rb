# frozen_string_literal: true

RSpec.describe Acumatica::SalesOrder do
  it_behaves_like "acumatica resource", customer_id: "C1001"

  describe ".create" do
    subject(:sales_order) { described_class.create(body, expand: 'Details') }

    let(:client) { configure_client }

    before { client.login }

    after  { client.logout }

    context "with line details", vcr: { record: :new_episodes } do
      let(:body) do
        {
          customer_id: "C1001",
          order_total: "2.00",
          tax_total: "0.16",
          description: "Test!",
          details: [
            {
              inventory_id: "01-792584-",
              quantity: 2,
              line_description: "Dollar sale!",
              unit_price: 1
            }
          ]
        }
      end

      it 'creates a sales order with the details' do
        expect(sales_order.description).to eq(body[:description])
      end

      it 'creates the detail items', :aggregate_failures do
        expect(sales_order.details.length).to eq(body[:details].length)
        expect(sales_order.details.first['InventoryID']['value']).to(
          eq(body[:details].first[:inventory_id])
        )
      end
    end
  end
end
