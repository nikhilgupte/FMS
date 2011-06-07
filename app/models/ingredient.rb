class Ingredient < ActiveRecord::Base

  has_many :prices, :as => :priceable, :dependent => :delete_all
  belongs_to :tax
  belongs_to :custom_duty

  auto_strip :name, :code

  scope :having_price, where("ingredients.latest_price_id is not null")
  scope :with_name_or_code, lambda { |term| where("name ILIKE :name OR lower(code) ILIKE :code", { :name => "%#{term}%", :code => "#{term}%" }) }

  def gross_price(currency_code)
    latest_price = prices.in(currency_code).last
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
              ingredient.create_or_update_price(:currency => currency, :amount => amount, :as_on => as_on)
            end
          end
        end
      end
    end
  end

  def create_or_update_price(params)
    if(price = prices.in(params[:currency]).where(:as_on => params[:as_on]).first).present?
      price.update_attribute(:amount, params[:amount])
    else
      prices.in(params[:currency]).create! :amount => params[:amount], :as_on => params[:as_on]  
    end
  end

  def to_s
    "#{name} (##{code})"
  end
end
