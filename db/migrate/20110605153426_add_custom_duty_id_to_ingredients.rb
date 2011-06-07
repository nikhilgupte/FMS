class AddCustomDutyIdToIngredients < ActiveRecord::Migration
  def self.up
    add_column :ingredients, :custom_duty_id, :integer
    add_index :ingredients, :custom_duty_id
    add_foreign_key :ingredients, :custom_duty_id, :levies, :id, :on_delete => :restrict
  end

  def self.down
    remove_column :ingredients, :custom_duty_id
  end
end
