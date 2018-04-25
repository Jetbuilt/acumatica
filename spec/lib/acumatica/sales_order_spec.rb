# frozen_string_literal: true

RSpec.describe Acumatica::SalesOrder do
  it_behaves_like "acumatica resource", customer_id: 100_010
end
