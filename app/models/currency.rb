class Currency < ActiveRecord::Base

  validates :name, :code, :presence => true, :uniqueness => { :case_sensitive => false }

  has_many :prices, :as => :priceable, :dependent => :delete_all

  before_save :upcase_code

  class << self
    def find_by_code!(currency_code)
      currency = find_by_code(currency_code.to_s.upcase)
      raise ActiveRecord::NotFound unless currency
      currency
    end
  end

  private
  def upcase_code
    self.code.upcase!
  end
end
