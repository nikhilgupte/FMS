class CreateFormulationItems < ActiveRecord::Migration
  def self.up
    create_table :formulation_items do |t|
      t.references :formulation, :null => false
      t.references :compound, :null => false, :polymorphic => true
      t.float :quantity, :null => false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :formulation_items, :formulation_id
    add_foreign_key :formulation_items, :formulation_id, :formulations, :id, :on_delete => :cascade
    add_index :formulation_items, [:compound_type, :compound_id]
  end

  def self.down
    drop_table :formulation_items
  end
end
