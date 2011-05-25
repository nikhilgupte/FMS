class Formulation < ActiveRecord::Base

  belongs_to :owner, :class_name => 'User'

  validates :name, :product_year, :presence => true

  before_create :generate_code

  private 
  def generate_code
    self.code = "#{owner.prefix}-#{product_year}-#{Time.now.utc.to_i.to_s(36)}"
  end
end
