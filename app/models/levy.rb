class Levy < ActiveRecord::Base

  validates :name, :uniqueness => { :scope => :type, :case_insensitive => true }

  def to_s
    "#{name}: #{amount} %"
  end
end
