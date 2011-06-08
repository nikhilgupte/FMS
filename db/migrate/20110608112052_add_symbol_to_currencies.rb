class AddSymbolToCurrencies < ActiveRecord::Migration
  def self.up
    add_column :currencies, :symbol, :string
  end

  def self.down
    remove_column :currencies, :symbol
  end
end
