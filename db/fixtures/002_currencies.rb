Currency.seed :code, [
  { :code => "USD", :name => "United States Dollar", :symbol => '$' },
  { :code => "INR", :name => "Indian Rupee", :symbol => 'Rs.' },
  { :code => "EUR", :name => "Euro", :symbol => '&euro;' }
]
inr = Currency.find_by_code("INR")
prices = Price.seed :priceable_type, :priceable_id, [
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("USD").id, :currency_code => 'inr', :amount => 44.795, :applicable_from => Time.parse("2011-06-05") },
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("EUR").id, :currency_code => 'inr', :amount => 65.564, :applicable_from => Time.parse("2011-06-05") },
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("INR").id, :currency_code => 'inr', :amount => 1, :applicable_from => Time.parse("2011-06-05") }
]
