class LevyRate < ActiveRecord::Base
  belongs_to :levy

  default_scope order(:applicable_from)

  after_save :recalc_prices

  delegate :name, :ingredients, :to => :levy

  class << self
    def as_on(date)
      where(:applicable_from.lte => date.to_date).last
    end
  end

  def to_s
    "#{rate}% #{name}"
  end

  private

  def recalc_prices
    ingredients.having_price.each{|i| i.generate_gross_price(applicable_from) }
  end
end
