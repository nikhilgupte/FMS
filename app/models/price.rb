# coding: utf-8
class Price < ActiveRecord::Base

  #SUPPORTED_CURRENCIES = %w(INR USD EUR)
  SUPPORTED_CURRENCIES = { 'INR' => 'Rs', 'USD' => '$', 'EUR' => '€' }

  belongs_to :priceable, :polymorphic => true
  has_many :currencies, :class_name => 'PriceCurrency'

  default_scope order(:applicable_from)

  class << self
    def current
      as_on(Date.today)
    end

    def as_on(date)
      where(:applicable_from.lte => date.to_date).last
    end
  end

  def in?(currency_code)
    self.send("#{currency_code.to_s.downcase}?")
  end

  def amount(currency_code)
    self.send("#{currency_code.to_s.downcase}")
  end

  def to(currency_code)
    if in?(currency_code)
      return amount(currency_code)
    else
      target_currency_rate = Currency.find_by_code!(currency_code).prices.last.inr
      SUPPORTED_CURRENCIES.keys.each do |supported_currency|
        if in?(supported_currency)
          supported_currency_rate = Currency.find_by_code!(supported_currency).prices.last.inr
          return amount(supported_currency) * supported_currency_rate / target_currency_rate
        end
      end
    end
  end

end
