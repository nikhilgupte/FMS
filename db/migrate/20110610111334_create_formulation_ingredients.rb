class CreateFormulationIngredients < ActiveRecord::Migration
  def self.up
    create_table :formulation_ingredients do |t|
      t.references :formulation_item
      t.references :ingredient
      t.float :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :formulation_ingredients
  end
end
