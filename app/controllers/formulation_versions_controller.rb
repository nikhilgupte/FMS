class FormulationVersionsController < ApplicationController
  layout 'formulations'

  before_filter :load_formulation

  def index
    @versions = @formulation.versions
  end

  def load_formulation
    @formulation = Formulation.find(params[:fragrance_id] || params[:accord_id])
  end
end
