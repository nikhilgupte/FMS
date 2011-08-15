class FormulationItem < ActiveRecord::Base
  include SoftDeletable
  attr_writer :as_on_date

  UNIT_WEIGHT = 1

  belongs_to :formulation_version #, :touch => true
  belongs_to :compound, :polymorphic => true
  has_many :constituents, :class_name => 'FormulationIngredient'

  attr_accessor :compound_name

  validates :quantity, :presence => true, :numericality => { :greater_than => 0, :less_than => 1000 }
  validates :compound, :presence => true

  after_save :explode!

  default_scope order(:id)

  acts_as_audited :associated_with => :formulation_version

  def quantity_percentage
    quantity * 100.0 / formulation_version.total_quantity
  end

  def price_percentage(currency_code)
    price(currency_code) * 100 / formulation_version.unit_price(currency_code) rescue nil
  end

  def to_s
    [compound.to_s, "#{quantity} gms"].join(' - ')
  end

  def price(currency_code = 'INR')
    constituents.as_on(as_on_date).entries.sum{|c| c.price(currency_code)}
  end
  memoize :price

  def as_on_date
    @as_on_date ||= Time.now
  end

  def as_on(date)
    i = revision_at(date)
    i.as_on_date = date
    i
  end

  class << self
    def import_from_csv(file)
      CSV.read(file, :headers => true).each do |row|
        begin
          formulation_id = row['FragranceId'] || row['AccordId']
          formulation = Formulation.find_by_origin_formula_id!(formulation_id)
          params = {
            :compound => Ingredient.find_by_code(row['CompId']) || Accord.find_by_origin_formula_id!(row['CompId']),
            :quantity => row['CompQty']
          }
          formulation.items.create_or_update(params)
        rescue
          nil
        end
      end
    end

    def create_or_update(params)
      if item = where({ :compound_type => params[:compound].class.name, :compound_id => params[:compound].id}).first
        item.update_attributes! params
      else
        item = create! params
      end
      item
    end
  end

  def explode!
    constituents.destroy_all    
    if compound.is_a?(Ingredient)
      constituents.create! :ingredient => compound, :quantity => self.quantity
    else
      #compound.items.current.each do |ci|
        compound.constituents.current.each do |i|
          #constituents.create! :ingredient => c.ingredient, :quantity => c.quantity/compound.net_weight
          constituents.create! :ingredient => i.ingredient, :quantity => (i.quantity / compound.quantity) * self.quantity
        end
      #end
    end
  end
end
