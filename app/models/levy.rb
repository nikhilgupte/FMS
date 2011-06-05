class Levy < ActiveRecord::Base

  validates :name, :uniqueness => { :scope => :type, :case_insensitive => true }
end
