# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :price_currency do |f|
  f.price nil
  f.currency_code "MyString"
  f.amount 1.5
end
