class AddIngredientPriceListIdToIngredientPrices < ActiveRecord::Migration
  def self.up
    add_column :ingredient_prices, :ingredient_price_list_id, :integer
    add_index :ingredient_prices, :ingredient_price_list_id
    add_foreign_key :ingredient_prices, :ingredient_price_list_id, :ingredient_price_lists, :id, :on_delete => :cascade
  end

  def self.down
    remove_column :ingredient_prices, :ingredient_price_list_id
  end
end
