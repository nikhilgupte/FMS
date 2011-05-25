class Ingredient < ActiveRecord::Base

  has_many :prices, :as => :priceable
  auto_strip :name, :code
end
