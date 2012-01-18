class Ingredient < ActiveRecord::Base
  acts_as_audited

  UNIT_WEIGHT = 1000

  has_many :prices, :class_name => 'IngredientPrice'
  belongs_to :tax
  belongs_to :custom_duty

  auto_strip :name, :code

  scope :with_price, lambda { |as_on = Date.today| where("ingredients.id in (select ingredient_id from ingredient_prices where applicable_from <= :applicable_from)", :applicable_from => as_on) }
  scope :with_gross_price, lambda { |as_on = Date.today| where("ingredients.id in (select ingredient_id from ingredient_prices where applicable_from <= :applicable_from and ingredient_price_list_id is not null)", :applicable_from => as_on) }
  scope :with_name_or_code, lambda { |term| with_gross_price.where("name ILIKE :name OR lower(code) ILIKE :code", { :name => "%#{term}%", :code => "#{term}%" }) }

  def priced?
    prices.exists?
  end

  def gross_price(opts = {})
    opts.reverse_merge!(ThreadLocal.price_preferences)
    p = prices.gross.as_on(opts[:as_on])
  end

  def price_per_gram(opts = {})
    opts.reverse_merge!(ThreadLocal.price_preferences)
    gross_price(opts).in(opts[:currency_code]) / UNIT_WEIGHT #rescue nil
  end

  class << self
    def find_by_code(code)
      where("lower(code) = ?", code.strip.downcase).first
    end
    
    def import(file)
      CSV.read(file, :headers => true, :header_converters => :downcase).each do |row|
        code = row['code'].strip
        ingredient = Ingredient.find_by_code(row['code']) || Ingredient.new(:code => code)
        ingredient.name = row['name']
        ingredient.save
      end
    end

    def import_prices(file, applicable_from = Date.today)
      CSV.read(file, :headers => true, :header_converters => :downcase).each do |row|
        if(ingredient = Ingredient.find_by_code(row['code'])).present?
          prices = { :inr => row['inr'], :usd => row['usd'], :eur => row['eur'] }
          as_on = applicable_from
          if row['applicable_from'].present?
            as_on = Date.parse(row['applicable_from'])
          end
          ingredient.create_or_update_price(as_on, prices)
        end
      end
    end
  end

  def create_or_update_price(as_on, price_values)
    price = prices.applicable_from(as_on).first || prices.build(:applicable_from => as_on)
    price.attributes = price_values
    price.save
  end

  def to_s
    "#{name} (##{code})"
  end

  def build_gross_price(applicable_from)
    gross_price = prices.build :applicable_from => applicable_from
    net_price = prices.net.as_on(applicable_from)
    if net_price.in?(:inr)
      tax_rate = tax.rate(applicable_from) rescue 0
      gross_price.inr = net_price.inr * (1 + (tax_rate||0) / 100.0)
    else
      custom_duty_rate = custom_duty.rate(applicable_from) rescue 0
      gross_price.inr = net_price.to(:inr) * (1 + (custom_duty_rate||0) / 100.0) 
    end
    gross_price.usd = net_price.to(:usd)
    gross_price.eur = net_price.to(:eur)
    gross_price
  end
end
