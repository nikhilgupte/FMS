class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.references :priceable, :polymorphic => true
      t.string :currency_code, :null => false
      t.decimal :amount, :precision => 8, :scale => 2
      t.date :applicable_from, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :prices
  end
end
