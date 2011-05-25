class CreateFormulations < ActiveRecord::Migration
  def self.up
    create_table :formulations do |t|
      t.string :type
      t.string :code
      t.string :name
      t.string :state
      t.integer :owner_id
      t.text :top_note
      t.text :middle_note
      t.text :base_note
      t.integer :product_year
      t.string :origin_formula_id

      t.timestamps
    end
    add_index :formulations, :owner_id
    add_index :formulations, :type
    add_index :formulations, :state
    add_index :formulations, :code, :unique => true, :case_sensitive => false
  end

  def self.down
    drop_table :formulations
  end
end
