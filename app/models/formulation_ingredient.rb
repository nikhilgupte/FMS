class FormulationIngredient < ActiveRecord::Base
  include SoftDeletable
  belongs_to :formulation_item
  belongs_to :ingredient

  def price(currency_code)
    (ingredient.price_per_gram(currency_code)) * quantity
  end
end
