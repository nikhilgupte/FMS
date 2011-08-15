class CreateFormulationVersions < ActiveRecord::Migration
  def self.up
    create_table :formulation_versions do |t|
      t.belongs_to :formulation, :null => false
      t.string :name, :null => false
      t.string :state, :null => false
      t.text :top_note
      t.text :middle_note
      t.text :base_note

      t.timestamps
    end
    add_index :formulation_versions, :state
    add_index :formulation_versions, :formulation_id
    add_foreign_key :formulation_versions, :formulation_id, :formulations, :id, :on_delete => :cascade
  end

  def self.down
    drop_table :formulation_versions
  end
end
