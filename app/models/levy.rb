class Levy < ActiveRecord::Base

  validates :name, :uniqueness => { :scope => :type, :case_insensitive => true }
  has_many :rates, :class_name => 'LevyRate'

  def rate(as_on = Date.today)
    rates.as_on(as_on).try :rate
  end

  def to_s
    "#{rate || 0}% #{name}"
  end

end
