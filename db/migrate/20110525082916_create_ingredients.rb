class CreateIngredients < ActiveRecord::Migration
  def self.up
    create_table :ingredients do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_index :ingredients, :code, :unique => true, :case_sensitive => false
  end

  def self.down
    drop_table :ingredients
  end
end
