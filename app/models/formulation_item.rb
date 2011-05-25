class FormulationItem < ActiveRecord::Base
  include SoftDeletable
  belongs_to :formulation
  belongs_to :compound, :polymorphic => true

  class << self
    def import_from_csv(file)
      CSV.read(file, :headers => true).each do |row|
        begin
          fragrance = Fragrance.find_by_origin_formula_id!(row['FragranceId'])
          params = {
            :compound => Ingredient.find_by_code(row['CompId']) || Accord.find_by_origin_formula_id!(row['CompId']),
            :quantity => row['CompQty']
          }
          fragrance.items.create_or_update(params)
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


end
