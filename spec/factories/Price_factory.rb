# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :price do |f|
  f.priceable nil
  f.currency_code "MyString"
  f.amount "9.99"
end
