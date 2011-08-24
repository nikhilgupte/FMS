class CreateIngredientPriceLists < ActiveRecord::Migration
  def self.up
    create_table :ingredient_price_lists do |t|
      t.date :applicable_from, :null => false, :unique => true
      t.datetime :generated_at
      t.integer :size

      t.timestamps
    end
  end

  def self.down
    drop_table :ingredient_price_lists
  end
end
