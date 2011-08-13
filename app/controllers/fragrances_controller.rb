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
    if params[:as_on].present?
      @fragrance = @fragrance.as_on(params[:as_on])
      @items = @fragrance.current_items
      flash.now[:notice] = "You are viewing an older version (#{Time.parse(params[:as_on]).to_s(:long)}) of this fragrance."
    else
      @items = @fragrance.items.current
    end
  end

  def new
    if params[:copy_of_id].present?
      original = Fragrance.find(params[:copy_of_id])
      @fragrance = original.copy(params[:as_on])
      flash.now[:notice] = "Copied from #{original}"
      if params[:as_on].present?
        flash.now[:notice] << " version (#{Time.parse(params[:as_on]).to_s(:long)})"
      end
    else
      @fragrance = Fragrance.new
      3.times{ @fragrance.items.build }
    end
    @fragrance.product_year = Time.now.year
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
