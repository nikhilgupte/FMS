class Price < ActiveRecord::Base

  SUPPORTED_CURRENCIES = %w(INR USD EUR)

  belongs_to :priceable, :polymorphic => true

  default_scope order(:as_on)

  SUPPORTED_CURRENCIES.each do |supported_currency|
    supported_currency.downcase!
    define_method "#{supported_currency}?" do
      self.currency_code.downcase == supported_currency.downcase
    end

    define_method "to_#{supported_currency}" do
      if self.send("#{supported_currency}?")
        amount
      else
        target_currency_rate = Currency.find_by_code!(supported_currency).prices.last.to_inr
        current_currency_rate = currency.prices.last.to_inr
        amount * current_currency_rate / target_currency_rate
      end
    end
  end

  def currency
    Currency.find_by_code! currency_code
  end

  private

  class << self
    def in(currency_code)
      where(:currency_code => currency_code.to_s.upcase)
    end
  end

end
