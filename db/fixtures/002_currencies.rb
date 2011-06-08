Currency.seed :code, [
  { :code => "USD", :name => "United States Dollar", :symbol => '$' },
  { :code => "INR", :name => "Indian Rupee", :symbol => 'Rs.' },
  { :code => "EUR", :name => "Euro", :symbol => '&euro;' }
]
inr = Currency.find_by_code("INR")
Price.seed :priceable_type, :priceable_id, [
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("USD").id, :currency_code => 'INR', :amount => 44.795, :as_on => Time.parse("2011-06-05"), :latest => true },
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("EUR").id, :currency_code => 'INR', :amount => 65.564, :as_on => Time.parse("2011-06-05"), :latest => true },
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("INR").id, :currency_code => 'INR', :amount => 1, :as_on => Time.parse("2011-06-05"), :latest => true }
]
