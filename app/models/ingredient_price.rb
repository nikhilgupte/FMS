# coding: utf-8
class IngredientPrice < ActiveRecord::Base

  belongs_to :ingredient
  acts_as_audited :associated_with => :ingredient

  SUPPORTED_CURRENCIES = { 'INR' => 'Rs. ', 'USD' => '$', 'EUR' => '€' }

  belongs_to :priceable, :polymorphic => true
  #has_many :currencies, :class_name => 'PriceCurrency'
  scope :chronological, order(:applicable_from.asc)
  scope :net, where(:ingredient_price_list_id => nil)
  scope :gross, where(:ingredient_price_list_id.ne => nil)
  scope :applicable_from, lambda { |applicable_from = Date.today| select('distinct on (ingredient_id) *').where(:applicable_from.lte => applicable_from).order('ingredient_id, applicable_from desc') }

  validates :applicable_from, :timeliness => { :type => :date }, :uniqueness => { :scope => :ingredient_id, :message => "must be unique" }, :if => :net?
  validate :atleast_one_price

  class << self
    def current
      as_on(Date.today)
    end

    def as_on(date)
      #where(:applicable_from.lte => date.to_date).last
      applicable_from(date.to_date).first
    end
  end

  def in?(currency_code)
    self.send("#{currency_code.to_s.downcase}").present?
  end

  def amount(currency_code)
    self.send("#{currency_code.to_s.downcase}")
  end

  def in(currency_code)
    self.send currency_code.to_s.downcase
  end

  def to(currency_code)
    if in?(currency_code)
      return amount(currency_code)
    else
      target_currency_rate = Currency.find_by_code!(currency_code).prices.as_on(applicable_from).amount
      SUPPORTED_CURRENCIES.keys.each do |supported_currency|
        if in?(supported_currency)
          supported_currency_rate = Currency.find_by_code!(supported_currency).prices.as_on(applicable_from).amount
          return amount(supported_currency) * supported_currency_rate / target_currency_rate
        end
      end
    end
  end


  def net?
    ingredient_price_list_id.nil?
  end

  def gross?
    ingredient_price_list_id.present?
  end

  private

  def atleast_one_price
    unless inr || usd || eur
      errors.add(:base, "At least one price should be entered")
    end
  end
end
