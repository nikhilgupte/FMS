class CreateIngredientPrices < ActiveRecord::Migration
  def self.up
    create_table :ingredient_prices do |t|
      t.references :ingredient, :null => false
      t.decimal :inr, :precision => 8, :scale => 2
      t.decimal :usd, :precision => 8, :scale => 2
      t.decimal :eur, :precision => 8, :scale => 2
      t.date :applicable_from, :null => false

      t.timestamps
    end
    add_index :ingredient_prices, [:ingredient_id, :applicable_from]
    add_foreign_key :ingredient_prices, :ingredient_id, :ingredients, :id, :on_delete => :cascade
  end

  def self.down
    drop_table :ingredient_prices
  end
end
