require 'csv'
class Formulation < ActiveRecord::Base

  acts_as_audited
  has_associated_audits

  STATES = %w(draft active deleted locked)
  belongs_to :owner, :class_name => 'User'
  has_many :items, :class_name => 'FormulationItem', :dependent => :delete_all, :conditions => { :deleted_at => nil }
  has_many :all_items, :class_name => 'FormulationItem', :readonly => true
  has_many :constituent_ingredients, :through => :items

  validates :name, :product_year, :presence => true
  validates :state, :inclusion => STATES
  validates :origin_formula_id, :uniqueness => { :case_insensitive => true }, :allow_blank => true

  after_create :generate_code!

  default_value_for :state, "draft"

  accepts_nested_attributes_for :items, :reject_if => Proc.new{ |o| %w(compound_id quantity).all?{|f| o[f].blank?} }, :allow_destroy => true

  def changes
    (audits + associated_audits).sort_by(&:created_at).reverse
  end

  def to_s
    "#{name} (##{code})"
  end

  def net_weight
    items.sum(:quantity)
  end

  def as_on(date)
    date = Time.parse(date).utc if date.is_a?(String)
    date += 1 # to avoid time precision
    f = revision_at(date)
    f.clone.tap do |g|
      f.all_items.as_on(date).each do |item|
        g.items << (item.revision_at(date) || item).clone
      end
    end
  end

  def copy(as_on = nil)
    if as_on.present?
      copy = self.as_on(as_on)
    else
      copy = self.clone
      self.items.each do |item|
        copy.items << item.clone
      end
    end
    %w(name origin_formula_id product_year).each{|a| copy.send("#{a}=", nil)}
    copy
  end

  class << self
    def create_or_update(params)
      if frag = find_by_origin_formula_id(params[:origin_formula_id])
        frag.update_attributes! params
      else
        frag = create! params.reverse_merge(:owner => User.first)
      end
      frag
    end
  end

  def total_quantity
    @total_quantity ||= items.sum(:quantity)
  end

  def total_price(currency_code)
    @total_price ||= items.entries.sum{|i| i.price(currency_code)}
  end

  def unit_price(currency_code)
    total_price(currency_code) * 1000 / total_quantity
  end

  private 
  def generate_code!
    update_attribute :code, "#{owner.prefix}-#{product_year}-#{id.to_s(36).upcase.rjust(5, '0')}"
  end
end
