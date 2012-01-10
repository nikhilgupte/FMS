class FormulationVersionsController < ApplicationController
  layout 'formulations'

  before_filter :load_formulation, :only => [:new, :create, :index]

  def index
    @versions = @formulation.versions
  end

  def new
    original = @formulation.versions.find(params[:version_id])
    @version = original.build_copy
  end

  def create
    @formulation_version = @formulation.versions.build(params[:formulation_version])
    if @formulation_version.save
      redirect_to @formulation_version, :success => 'Formulation saved'
    else
      render :new
    end
  end

  def edit
    @formulation_version = FormulationVersion.find params[:id]
    @formulation = @formulation_version.formulation
    if @formulation_version.published?
      redirect_to :back, :notice => "This version cannot be modified"
    end
  end

  def publish
    @formulation_version = FormulationVersion.find params[:id]
    @formulation_version.publish!
    redirect_to @formulation_version.formulation, :flash => { :success => "#{@formulation_version} published" }
  end

  private
  def load_formulation
    @formulation = Formulation.find(params[:fragrance_id] || params[:accord_id])
  end
end
