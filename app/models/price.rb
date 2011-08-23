class Price < ActiveRecord::Base
  belongs_to :priceable

  class << self
    def as_on(date)
      where(:applicable_from.lte => date.to_date).last
    end
  end
end
