Currency.seed :code, [
  { :code => "USD", :name => "United States Dollar", :symbol => '$' },
  { :code => "INR", :name => "Indian Rupee", :symbol => 'Rs.' },
  { :code => "EUR", :name => "Euro", :symbol => '&euro;' }
]
inr = Currency.find_by_code("INR")
prices = Price.seed :priceable_type, :priceable_id, [
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("USD").id, :inr => 44.795, :as_on => Time.parse("2011-06-05"), :calculated => false },
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("EUR").id, :inr => 65.564, :as_on => Time.parse("2011-06-05"), :calculated => false },
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("INR").id, :inr => 1, :as_on => Time.parse("2011-06-05"), :calculated => false }
]
