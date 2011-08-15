class FragrancesController < ApplicationController
  layout 'formulations'

  def index
    @fragrances = Fragrance.all.paginate :page => params[:page], :per_page => 20
  end

  def history
    @fragrance = Fragrance.find params[:id]
    @changes = @fragrance.changes
  end

  def show
    @fragrance = Fragrance.find params[:id]
    if(version = params[:version]).present?
      @formulation_version = version == 'draft' ?  @fragrance.draft_version : @fragrance.version.find_by_tag(version)
    else
      @formulation_version = @fragrance.current_version
    end
    @items = @formulation_version.items.current
  end

  def new
    @fragrance = Fragrance.new
    @fragrance.build_draft_version.init
    #@fragrance.versions.build.init
  end

  def create
    @fragrance = current_user.fragrances.build params[:fragrance]
    if @fragrance.save
      redirect_to @fragrance, :flash => { :success => 'Fragrance created.' }
    else
      render :new
    end
  end

  def edit
    @fragrance = Fragrance.find params[:id]
    @fragrance.build_draft unless @fragrance.draft_version.present?
  end

  def update
    @fragrance = Fragrance.find params[:id]
    if @fragrance.update_attributes params[:fragrance]
      redirect_to fragrance_url(@fragrance, :version => 'draft'), :flash => { :success => "Fragrance updated" }
    else
      render :edit
    end
  end

  def publish
    @fragrance = Fragrance.find params[:id]
    @fragrance.draft_version.publish!
    redirect_to @fragrance, :flash => { :success => "Fragrance published" }
  end
end
