RSpec.describe Acumatica::Customer do
  it_behaves_like "acumatica resource", { customer_name: "ACME", tax_zone: "TX1" }
end
