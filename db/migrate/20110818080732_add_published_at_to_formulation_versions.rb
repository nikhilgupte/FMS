class AddPublishedAtToFormulationVersions < ActiveRecord::Migration
  def self.up
    add_column :formulation_versions, :published_at, :datetime
  end

  def self.down
    remove_column :formulation_versions, :published_at
  end
end
