class IngredientPricesController < ApplicationController
  before_filter :find_ingredient

  def create
    @price = @ingredient.prices.build params[:ingredient_price]
    if @price.save
      flash[:success] = "Added prices for '#{@price.applicable_from.to_s(:long)}'"
    end
  end

  private

  def find_ingredient
    @ingredient = Ingredient.find params[:ingredient_id]
  end
end
