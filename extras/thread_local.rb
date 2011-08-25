class ThreadLocal

  class << self

  def current_currency
    Currency.find_by_code! price_preferences[:currency_code].upcase
  end

  def current_as_on
    price_preferences[:as_on]
  end

  def price_preferences=(opts)
    opts = opts.present? ? opts.to_hash : {}
    opts.symbolize_keys!
    opts.reverse_merge!(:currency_code => 'INR', :as_on => Date.today)
    opts[:as_on] = Date.parse(opts[:as_on].to_s)
    Thread.current[:price_preferences] = opts
  end

  def price_preferences
    unless opts = Thread.current[:price_preferences]
      self.price_preferences = {}
    end
    Thread.current[:price_preferences]
  end

  end
end
