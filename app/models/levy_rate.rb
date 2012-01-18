class LevyRate < ActiveRecord::Base
  belongs_to :levy

  default_scope order(:applicable_from)

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

end
