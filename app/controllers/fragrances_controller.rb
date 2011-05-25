class FragrancesController < ApplicationController
  layout 'formulations'

  def index
    @fragrances = Fragrance.all.paginate :page => params[:page], :per_page => 20
  end
end
