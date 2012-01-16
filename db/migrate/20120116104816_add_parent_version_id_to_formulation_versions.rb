class AddParentVersionIdToFormulationVersions < ActiveRecord::Migration
  def self.up
    add_column :formulation_versions, :parent_version_id, :integer
    add_index :formulation_versions, :parent_version_id
  end

  def self.down
    remove_column :formulation_versions, :parent_version_id
  end
end
