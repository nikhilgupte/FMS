class Ingredient < ActiveRecord::Base

  has_many :prices, :as => :priceable, :dependent => :delete_all
  auto_strip :name, :code

  scope :with_name_or_code, lambda { |term| where("name ILIKE :term OR code ILIKE :term", { :term => "#{term}%" }) }

  class << self
    def find_by_code(code)
      where("lower(code) = ?", code.strip.downcase).first
    end
  end

  def to_s
    "#{name} (##{code})"
  end


end
