class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :prefix,              :null => false
      t.string    :first_name,          :null => false
      t.string    :last_name,           :null => false
      t.string    :email,               :null => false
      t.string    :crypted_password,    :null => false
      t.string    :password_salt,       :null => false
      t.string    :persistence_token,   :null => false
      t.string    :single_access_token, :null => false
      t.string    :perishable_token,    :null => false
      t.string    :time_zone
  
      t.datetime  :current_login_at                                   
      t.datetime  :last_login_at                                      
      t.string    :current_login_ip                                   
      t.string    :last_login_ip                                      

      t.timestamps
    end
    add_index :users, :email, :unique => true, :case_sensitive => false
    add_index :users, :prefix, :unique => true, :case_sensitive => false

  end

  def self.down
    drop_table :users
  end
end
