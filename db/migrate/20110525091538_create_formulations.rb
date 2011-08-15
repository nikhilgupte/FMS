class CreateFormulations < ActiveRecord::Migration
  def self.up
    create_table :formulations do |t|
      t.integer :current_version_id
      t.integer :owner_id
      t.string :type
      t.integer :product_year
      t.string :origin_formula_id
      t.string :code, :null => false, :unique => true
      t.integer :versions_count, :null => false, :default => 0

      t.timestamps
    end
    add_index :formulations, :owner_id
    add_index :formulations, :type
    add_index :formulations, :code, :unique => true, :case_sensitive => false
  end

  def self.down
    drop_table :formulations
  end
end
