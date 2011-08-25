class FormulationIngredient < ActiveRecord::Base
  #include SoftDeletable
  belongs_to :formulation_item
  belongs_to :ingredient

  #scope :with_prices, lambda { |currency_code = 'INR'| joins(:ingredient => { :prices => 

  def price(currency_code)
    (ingredient.price_per_gram(currency_code)) * quantity
  end

  class << self
    #def with_prices(as_on = Date.today, currency_code = 'INR')
    def with_prices(opts)
      opts.reverse_merge!(ThreadLocal.price_preferences)
      as_on = opts[:as_on]
      currency_code = opts[:currency_code]

      prices = "(SELECT distinct on (ingredient_id) * FROM ingredient_prices WHERE ingredient_prices.ingredient_price_list_id is not null and ingredient_prices.applicable_from <= '#{as_on.to_date.to_s(:db)}' ORDER BY ingredient_id, applicable_from desc) as prices"
      joins("inner join #{prices} on prices.ingredient_id = formulation_ingredients.ingredient_id").select("(#{currency_code.to_s.downcase} / 1000) as amount")
    end

    #def price(as_on = Date.today, currency_code = 'INR')
    def price(opts = {})
      opts.reverse_merge! ThreadLocal.price_preferences
      with_prices(opts).sum("formulation_ingredients.quantity * (#{opts[:currency_code].to_s.downcase} / 1000)")
    end
  end
end
