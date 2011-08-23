# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :levy_rate do |f|
  f.levy nil
  f.applicable_from "2011-08-21"
  f.rate 1.5
end
