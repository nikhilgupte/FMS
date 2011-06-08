class AccordsController < ApplicationController
  layout 'formulations'

  def index
    @accords = Accord.all.paginate :page => params[:page], :per_page => 20
  end

  def history
    @accord = Accord.find params[:id]
    @changes = @accord.changes
  end

  def show
    @accord = Accord.find params[:id]
    if params[:as_on].present?
      @accord = @accord.as_on(params[:as_on])
      @items = @accord.items
      flash.now[:notice] = "You are viewing an older version (#{Time.parse(params[:as_on]).to_s(:long)}) of this accord."
    else
      @items = @accord.items.current
    end
  end

  def new
    if params[:copy_of_id].present?
      original = Accord.find(params[:copy_of_id])
      @accord = original.copy(params[:as_on])
      flash.now[:notice] = "Copied from #{original}"
      if params[:as_on].present?
        flash.now[:notice] << " version (#{Time.parse(params[:as_on]).to_s(:long)})"
      end
    else
      @accord = Accord.new
      3.times{ @accord.items.build }
    end
    @accord.product_year = Time.now.year
  end

  def create
    @accord = current_user.accords.build params[:accord]
    if @accord.save
      redirect_to @accord, :flash => { :success => 'Accord created.' }
    else
      render :new
    end
  end

  def edit
    @accord = Accord.find params[:id]
  end

  def update
    @accord = Accord.find params[:id]
    if @accord.update_attributes params[:accord]
      redirect_to @accord, :flash => { :success => "Accord updated" }
    else
      render :edit
    end
  end
end
