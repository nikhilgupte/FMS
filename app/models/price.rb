class Price < ActiveRecord::Base

  belongs_to :priceable, :polymorphic => true
  belongs_to :currency

  default_scope order(:as_on)

  after_create :set_if_latest

  private

  class << self
    def in(currency)
      currency = Currency.find_by_code(currency.to_s.upcase) unless currency.is_a?(Currency)
      where(:currency_id => currency.id)
    end
  end

  def set_if_latest
    priceable.prices.in(currency).update_all(:latest => false)
    priceable.prices.in(currency).last.update_attribute(:latest, true)
  end
end
