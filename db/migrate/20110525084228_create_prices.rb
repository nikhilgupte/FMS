class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.references :priceable, :polymorphic => true
      t.references :currency
      t.datetime :as_on, :null => false
      t.float :value
      t.boolean :latest, :null => false

      t.timestamps
    end
    add_index :prices, :latest
    add_index :prices, :currency_id
    add_index :prices, [:priceable_type, :priceable_id]
    add_foreign_key :prices, :currency_id, :currencies, :id, :on_delete => :cascade
  end

  def self.down
    drop_table :prices
  end
end
