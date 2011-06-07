class FragrancesController < ApplicationController
  layout 'formulations'

  def index
    @fragrances = Fragrance.all.paginate :page => params[:page], :per_page => 20
  end

  def history
    @fragrance = Fragrance.find params[:id]
    @changes = (@fragrance.audits + @fragrance.associated_audits).sort_by(&:created_at).reverse
  end

  def show
    @fragrance = Fragrance.find params[:id]
    if params[:as_on].present?
      @fragrance = @fragrance.as_on(params[:as_on])
      @items = @fragrance.items
    else
      @items = @fragrance.items.current
    end
  end

  def new
    @fragrance = Fragrance.new
    3.times{ @fragrance.items.build }
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
  end

  def update
    @fragrance = Fragrance.find params[:id]
    if @fragrance.update_attributes params[:fragrance]
      redirect_to @fragrance, :flash => { :success => "Fragrance updated" }
    else
      render :edit
    end
  end
end
