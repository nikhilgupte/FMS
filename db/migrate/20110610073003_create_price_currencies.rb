class CreatePriceCurrencies < ActiveRecord::Migration
  def self.up
    create_table :price_currencies do |t|
      t.references :price
      t.string :currency_code
      t.float :amount

      t.timestamps
    end
    add_index :price_currencies, [:price_id, :currency_code], :unique => true
    add_foreign_key :price_currencies, :price_id, :prices, :id, :on_delete => :cascade
  end

  def self.down
    drop_table :price_currencies
  end
end
