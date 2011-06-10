class FormulationIngredient < ActiveRecord::Base
  belongs_to :formulation_item
  belongs_to :ingredient

  def price(currency_code)
    (ingredient.unit_price(currency_code) / 1000) * quantity rescue nil
  end
end
