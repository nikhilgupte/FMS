class Ingredient < ActiveRecord::Base

  has_many :prices, :as => :priceable, :dependent => :delete_all
  auto_strip :name, :code

  class << self
    def find_by_code(code)
      where("lower(code) = ?", code.strip.downcase).first
    end
  end
end
