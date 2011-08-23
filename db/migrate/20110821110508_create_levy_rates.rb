class CreateLevyRates < ActiveRecord::Migration
  def self.up
    create_table :levy_rates do |t|
      t.belongs_to :levy, :null => false
      t.date :applicable_from, :null => false
      t.float :rate, :null => false

      t.timestamps
    end
    add_index :levy_rates, [:levy_id, :applicable_from], :unique => true
    add_foreign_key :levy_rates, :levy_id, :levies, :id, :on_delete => :cascade
  end

  def self.down
    drop_table :levy_rates
  end
end
