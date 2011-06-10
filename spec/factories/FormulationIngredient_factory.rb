# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :formulation_ingredient do |f|
  f.formulation_item nil
  f.ingredient nil
  f.quantity 1.5
end
