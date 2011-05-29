class IngredientsController < ApplicationController

  def autocomplete
    render :json => Ingredient.with_name_or_code(params[:term]).limit(10).collect{|i| { :id => i.id, :value => i.to_s } }
  end
end
