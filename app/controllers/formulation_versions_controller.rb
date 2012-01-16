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

  def show
    @formulation_version = FormulationVersion.find params[:id]
    @formulation = @formulation_version.formulation
  end

  def edit
    @formulation_version = FormulationVersion.find params[:id]
    @formulation = @formulation_version.formulation
    unless @formulation_version.editable?
      redirect_to :back, :notice => "This version cannot be modified"
    end
  end

  def update
    @formulation_version = FormulationVersion.find params[:id]
    unless @formulation_version.editable?
      redirect_to :back, :notice => "This version cannot be modified"
    end
    if @formulation_version.update_attributes params[:formulation_version]
      redirect_to @formulation_version, :flash => { :success => "Fragrance updated" }
    else
      @formulation = @formulation_version.formulation
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
