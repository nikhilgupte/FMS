class CreateLevies < ActiveRecord::Migration
  def self.up
    create_table :levies do |t|
      t.string :type, :null => false
      t.string :name, :null => false
      t.float :amount, :null => false

      t.timestamps
    end
    add_index :levies, [:type, :name], :unique => true, :case_sensitive => false
  end

  def self.down
    drop_table :levies
  end
end
