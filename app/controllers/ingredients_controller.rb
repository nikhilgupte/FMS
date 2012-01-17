class IngredientsController < ApplicationController

  def autocomplete
    render :json => Ingredient.with_gross_price.with_name_or_code(params[:term]).limit(10).collect{|i| { :id => i.id, :value => i.to_s, :price_per_gram => i.price_per_gram.round(2) } }
  end

  def index
    @search = Ingredient.with_price.search(params[:search])    
    @ingredients = @search.paginate(:page => params[:page], :per_page => 50)
  end

  def show
    @ingredient = Ingredient.find params[:id]
  end
end
