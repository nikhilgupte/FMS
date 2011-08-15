class AddVersionNumberToFormulationVersions < ActiveRecord::Migration
  def self.up
    add_column :formulation_versions, :version_number, :string, :null => false
    add_index :formulation_versions, [:formulation_id, :version_number], :unique => true
  end

  def self.down
    remove_column :formulation_versions, :version_number
  end
end
