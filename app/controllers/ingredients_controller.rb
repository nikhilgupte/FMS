class IngredientsController < ApplicationController

  def autocomplete
    render :json => Ingredient.with_name_or_code(params[:term]).limit(10).collect{|i| { :id => i.id, :value => i.to_s } }
  end

  def index
    @search = Ingredient.with_price.search(params[:search])    
    @ingredients = @search.paginate(:page => params[:page], :per_page => 50)
  end

  def show
    @ingredient = Ingredient.find params[:id]
  end
end
