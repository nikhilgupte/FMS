class Price < ActiveRecord::Base

  SUPPORTED_CURRENCIES = %w(INR USD EUR)

  belongs_to :priceable, :polymorphic => true
  has_many :currencies, :class_name => 'PriceCurrency'

  default_scope order(:as_on)

  def in?(currency_code)
    currency_code = currency_code.to_s.upcase
    currencies.where(:currency_code => currency_code).exists?
  end

  def in(currency_code)
    currency_code = currency_code.to_s.upcase
    currencies.where(:currency_code => currency_code).last.try(:amount)
  end

  def to(currency_code)
    currency_code = currency_code.to_s.upcase
    if in?(currency_code)
      amount = currencies.where(:currency_code => currency_code).last.amount
    else
      target_currency_rate = Currency.find_by_code!(currency_code).prices.last.in(:inr)
      available_currency = SUPPORTED_CURRENCIES.find{|c| self.in?(c)}
      available_currency_rate = Currency.find_by_code!(available_currency).prices.last.in(:inr)
       available_amount = currencies.where(:currency_code => available_currency).last.amount
       amount = available_amount * available_currency_rate / target_currency_rate
    end
  end

end
