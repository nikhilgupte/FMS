class CreateFormulationItems < ActiveRecord::Migration
  def self.up
    create_table :formulation_items do |t|
      t.references :formulation_version, :null => false
      t.references :compound, :null => false, :polymorphic => true
      t.float :quantity, :null => false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :formulation_items, :formulation_version_id
    add_foreign_key :formulation_items, :formulation_version_id, :formulation_versions, :id, :on_delete => :cascade
    add_index :formulation_items, [:compound_type, :compound_id]
  end

  def self.down
    drop_table :formulation_items
  end
end
