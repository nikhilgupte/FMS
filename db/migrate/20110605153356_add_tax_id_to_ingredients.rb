class AddTaxIdToIngredients < ActiveRecord::Migration
  def self.up
    add_column :ingredients, :tax_id, :integer
    add_index :ingredients, :tax_id
    add_foreign_key :ingredients, :tax_id, :levies, :id, :on_delete => :restrict
  end

  def self.down
    remove_column :ingredients, :tax_id
  end
end
