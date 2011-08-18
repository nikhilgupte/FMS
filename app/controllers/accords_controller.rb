class AccordsController < FormulationsController
  layout 'formulations'

  def index
    @accords = Accord.all.paginate :page => params[:page], :per_page => 20
  end

  def new
    @formulation = Accord.new
    @formulation.build_draft_version.init
    render "formulations/new"
  end

  def create
    @formulation = current_user.accords.build params[:accord]
    if @formulation.save
      redirect_to @formulation, :flash => { :success => 'Accord created.' }
    else
      render "formulations/new"
    end
  end

  def update
    @formulation = Accord.find params[:id]
    if @formulation.update_attributes params[:accord]
      redirect_to accord_url(@formulation, :version => 'draft'), :flash => { :success => "Accord updated" }
    else
      render "formulations/edit"
    end
  end

  def autocomplete
    render :json => Accord.with_name_or_code(params[:term]).limit(10).collect{|i| { :id => i.id, :value => i.to_s } }
  end
end
