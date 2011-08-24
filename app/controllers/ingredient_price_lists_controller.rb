class IngredientPriceListsController < ApplicationController

  layout 'ingredients'

  def index
    @price_lists = IngredientPriceList.all.reverse.paginate(:page => params[:page])
  end

  def create
    @price_list = IngredientPriceList.new params[:ingredient_price_list]
    if @price_list.save
      @price_list.generate #OPTIMIZE: move into background
      flash[:success] = "Generated price list as on #{@price_list.applicable_from.to_s(:long)}"
    end
  end

  def update
    @price_list = IngredientPriceList.find params[:id]
    @price_list.generate #OPTIMIZE: move into background
    redirect_to ingredient_price_lists_url :flash => { :success => "Recalculated price list as on #{@price_list.applicable_from.to_s(:long)}" }
  end
end
