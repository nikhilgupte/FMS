class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :name, :null => false
      t.string :code, :null => false

      t.timestamps
    end
    add_index :currencies, :name, :unique => true, :case_sensitive => false
    add_index :currencies, :code, :unique => true, :case_sensitive => false
  end

  def self.down
    drop_table :currencies
  end
end
