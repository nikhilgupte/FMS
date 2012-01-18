Tax.seed :name, [
  { :name => "TAX #1", :type => 'Tax' },
  { :name => "TAX #2", :type => 'Tax' }
]
CustomDuty.seed :name, [
  { :name => "CVD #1", :type => 'CustomDuty' },
  { :name => "CVD #2", :type => 'CustomDuty' }
]

Levy.all.each do |levy|
  LevyRate.seed :levy_id, :levy_id => levy.id, :applicable_from => '2011-01-01', :rate => (1000 + rand(1000)) / 100
end
