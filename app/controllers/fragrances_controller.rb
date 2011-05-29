class FragrancesController < ApplicationController
  layout 'formulations'

  def index
    @fragrances = Fragrance.all.paginate :page => params[:page], :per_page => 20
  end

  def show
    @fragrance = Fragrance.find params[:id]
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
