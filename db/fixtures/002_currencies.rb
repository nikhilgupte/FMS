Currency.seed :code, [
  { :code => "USD", :name => "United States Dollar" },
  { :code => "INR", :name => "Indian Rupee" },
  { :code => "EUR", :name => "Euro" }
]
inr = Currency.find_by_code("INR")
Price.seed :priceable_type, :priceable_id, [
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("USD").id, :currency => inr, :amount => 44.795, :as_on => Time.parse("2011-06-05"), :latest => true },
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("EUR").id, :currency => inr, :amount => 65.564, :as_on => Time.parse("2011-06-05"), :latest => true }
]
