class IngredientPriceList < ActiveRecord::Base
  acts_as_audited

  default_scope order(:applicable_from)

  has_many :ingredient_prices, :dependent => :delete_all

  validates :applicable_from, :timeliness => { :type => :date }, :uniqueness => { :message => "must be unique" }

  def generate
    transaction do
      ingredient_prices.delete_all
      Ingredient.with_price(applicable_from).each do |ingredient|
        self.ingredient_prices << ingredient.build_gross_price(applicable_from)
      end
      self.size = ingredient_prices.size
      self.generated_at = Time.now
      save!
    end
  end

  def generated_by
    audits.present? ? audits.first.user : nil
  end
end
