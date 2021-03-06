class FormulationsController < ApplicationController

  def show
    @formulation = Formulation.find params[:id]
    if(version = params[:version]).present?
      @formulation_version = version == 'draft' ?  @formulation.draft_version : @formulation.versions.find_by_version_number(version)
    else
      @formulation_version = @formulation.current_version
    end
    render "formulations/show"
  end

  def edit
    @formulation = Formulation.find params[:id]
    @formulation.create_draft_version unless @formulation.draft_version.present?
    render "formulations/edit"
  end

  def publish
    @formulation = Formulation.find params[:id]
    @formulation.draft_version.publish!
    redirect_to @formulation, :flash => { :success => "#{@formulation.class.name} published" }
  end
end
