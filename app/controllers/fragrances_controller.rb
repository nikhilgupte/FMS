class FragrancesController < FormulationsController
  layout 'formulations'

  def index
    @fragrances = Fragrance.all.paginate :page => params[:page], :per_page => 20
  end

  def new
    @formulation = Fragrance.new
    #@formulation.build_draft_version.init
    @formulation.versions.build.init
    render "formulations/new"
  end

  def create
    @formulation = current_user.fragrances.build params[:fragrance]
    if @formulation.save
      redirect_to @formulation, :flash => { :success => 'Fragrance created.' }
    else
      render :template => "formulations/new"
    end
  end

  def update
    @formulation = Fragrance.find params[:id]
    if @formulation.update_attributes params[:fragrance]
      redirect_to @formulation, :flash => { :success => "Fragrance updated" }
    else
      render "formulations/edit"
    end
  end

end
