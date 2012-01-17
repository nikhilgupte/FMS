class Currency < ActiveRecord::Base

  validates :name, :code, :presence => true, :uniqueness => { :case_sensitive => false }

  has_many :prices, :as => :priceable, :dependent => :delete_all

  before_save :upcase_code

  def to_s
    code
  end

  class << self
    %w(usd eur).each do |code|
      define_method "#{code}_to_inr" do |amount, as_on = Date.today|
        amount * find_by_code!(code).prices.as_on(as_on).amount
      end
      define_method "inr_to_#{code}" do |amount, as_on = Date.today|
        amount / find_by_code!(code).prices.as_on(as_on).amount
      end
    end

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
