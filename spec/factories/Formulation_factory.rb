# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :formulation do |f|
  f.type "MyString"
  f.code "MyString"
  f.name "MyString"
  f.state "MyString"
  f.owner_id 1
  f.top_note "MyText"
  f.middle_note "MyText"
  f.base_note "MyText"
  f.product_year 1
  f.origin_formula_id "MyString"
end
