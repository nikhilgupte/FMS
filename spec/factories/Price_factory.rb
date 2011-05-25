# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :price do |f|
  f.references ""
  f.currency "MyString"
  f.value 1.5
end
