# frozen_string_literal: true

RSpec.describe Acumatica::Customer do
  it_behaves_like "acumatica resource", customer_id: "123", customer_name: "ACME",
                                        tax_zone: "AVALARA"
end
