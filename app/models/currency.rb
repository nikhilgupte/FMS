class Currency < ActiveRecord::Base

  validates :name, :code, :presence => true, :uniqueness => { :case_sensitive => false }

  has_many :prices, :as => :priceable, :dependent => :delete_all

  before_save :upcase_code

  private
  def upcase_code
    self.code.upcase!
  end
end
