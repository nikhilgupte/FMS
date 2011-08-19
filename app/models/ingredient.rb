class Ingredient < ActiveRecord::Base

  UNIT_WEIGHT = 1000

  has_many :prices, :as => :priceable, :dependent => :delete_all
  #has_one :current_price, :as => :priceable, :conditions => proc {["prices.applicable_from <= ?", Time.now]}, :as => :priceable, :class_name => 'Price'
  belongs_to :tax
  belongs_to :custom_duty

  auto_strip :name, :code

  scope :having_price, where("ingredients.id in (select priceable_id from prices where priceable_type = 'Ingredient')")
  scope :with_name_or_code, lambda { |term| having_price.where("name ILIKE :name OR lower(code) ILIKE :code", { :name => "%#{term}%", :code => "#{term}%" }) }

  def priced?
    prices.exists?
  end

  def gross_price(currency_code, as_on = Date.today)
    currency_code = currency_code.to_s.downcase.to_sym
    price = prices.as_on(as_on)
    if currency_code == :inr
      if price.in?(:inr)
        amount = price.to(:inr) * (1 + (tax.try(:amount) || 0))
      else
        amount = price.to(:inr) * (1 + (custom_duty.try(:amount) || 0))
      end
    else
      amount = price.to(currency_code)
    end
  end

  def price_per_gram(currency_code = 'INR')
    gross_price(currency_code) / UNIT_WEIGHT rescue nil
  end

  class << self
    def find_by_code(code)
      where("lower(code) = ?", code.strip.downcase).first
    end
    
    def import_prices(file, as_on = nil)
      CSV.read(file, :headers => true, :header_converters => :downcase).each do |row|
        if(ingredient = Ingredient.find_by_code(row['code'])).present?
          prices = { :inr => row['inr'], :usd => row['usd'], :eur => row['eur'] }
          as_on = row['date'] || row['as_on'] || Date.today
          ingredient.create_or_update_price(as_on, prices)
        end
      end
    end

    def create_or_update_price(as_on, price_values)
      price = prices.where(:as_on => as_on).first || prices.build(:as_on => as_on)
      price.attributes = price_values.merge(:calculated => false)
      price.save!
    end
  end

  def to_s
    "#{name} (##{code})"
  end

end
