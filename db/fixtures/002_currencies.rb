Currency.seed :code, [
  { :code => "USD", :name => "United States Dollar", :symbol => '$' },
  { :code => "INR", :name => "Indian Rupee", :symbol => 'Rs.' },
  { :code => "EUR", :name => "Euro", :symbol => '&euro;' }
]
inr = Currency.find_by_code("INR")
prices = Price.seed :priceable_type, :priceable_id, [
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("USD").id, :as_on => Time.parse("2011-06-05") },
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("EUR").id, :as_on => Time.parse("2011-06-05") },
  { :priceable_type => 'Currency', :priceable_id => Currency.find_by_code("INR").id, :as_on => Time.parse("2011-06-05") }
]

PriceCurrency.seed :price_id, [
  { :price_id => prices.select{|p| p.priceable.code == 'INR'}.first.id, :currency_code => 'INR', :amount => 1 },
  { :price_id => prices.select{|p| p.priceable.code == 'USD'}.first.id, :currency_code => 'INR', :amount => 44.795 },
  { :price_id => prices.select{|p| p.priceable.code == 'EUR'}.first.id, :currency_code => 'INR', :amount => 65.564 }
]
