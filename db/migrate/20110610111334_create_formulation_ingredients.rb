class CreateFormulationIngredients < ActiveRecord::Migration
  def self.up
    create_table :formulation_ingredients do |t|
      t.references :formulation_item
      t.references :ingredient
      t.float :quantity
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :formulation_ingredients, :formulation_item_id
    add_foreign_key :formulation_ingredients, :formulation_item_id, :formulation_items, :id, :on_delete => :cascade
  end

  def self.down
    drop_table :formulation_ingredients
  end
end
