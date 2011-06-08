class Ingredient < ActiveRecord::Base

  UNIT_WEIGHT = 1000

  has_many :prices, :as => :priceable, :dependent => :delete_all
  belongs_to :tax
  belongs_to :custom_duty

  auto_strip :name, :code

  scope :having_price, where("ingredients.id in (select priceable_id from prices where priceable_type = 'Ingredient')")
  scope :with_name_or_code, lambda { |term| where("name ILIKE :name OR lower(code) ILIKE :code", { :name => "%#{term}%", :code => "#{term}%" }) }

  def gross_price(currency_code, as_on = Date.today)
    currency_code = currency_code.to_s.upcase
    price = price(currency_code, as_on)
    if currency_code == 'INR'
      if price.inr?
        amount = price.amount * (1 + (tax.try(:amount) || 0))
      else
        amount = price.amount * (1 + (custom_duty.try(:amount) || 0))
      end
    else
      amount = price.send("to_#{currency_code}")
    end
  end

  def unit_price(currency_code)
    gross_price(currency_code) / UNIT_WEIGHT rescue '?'
  end

  class << self
    def find_by_code(code)
      where("lower(code) = ?", code.strip.downcase).first
    end
    
    def import_prices(file)
      CSV.read(file, :headers => true, :header_converters => :downcase).each do |row|
        if(ingredient = Ingredient.find_by_code(row['code'])).present?
          params = { :inr => row['inr'], :usd => row['usd'], :eur => row['eur'] }
          as_on = row['date'] || row['as_on']
          params.keys.each do |currency|
            if(amount = params[currency]).present?
              ingredient.create_or_update_price(:currency_code => currency, :amount => amount, :as_on => as_on)
            end
          end
        end
      end
    end
  end

  def create_or_update_price(params)
    if(price = prices.in(params[:currency_code]).where(:as_on => params[:as_on]).first).present?
      price.update_attribute(:amount, params[:amount])
    else
      prices.in(params[:currency_code]).create! :amount => params[:amount], :as_on => params[:as_on]  
    end
  end

  def to_s
    "#{name} (##{code})"
  end

  def price(currency_code, as_on = Date.today)
    currency_codes = [currency_code] + (Price::SUPPORTED_CURRENCIES - [currency_code])
    currency_codes.each do |currency_code|
      price = prices.in(currency_code).last
      return price if price.present?
    end
    nil
  end
end
