class IngredientPriceList < ActiveRecord::Base

  has_many :ingredient_prices

  validates :applicable_from, :timeliness => { :type => :date }, :uniqueness => true

  def generate
    Ingredient.with_price(applicable_from).each do |ingredient|
      self.ingredient_prices << ingredient.build_gross_price(applicable_from)
    end
  end
end
