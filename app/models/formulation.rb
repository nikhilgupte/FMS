require 'csv'
class Formulation < ActiveRecord::Base

  acts_as_audited
  has_associated_audits

  attr_accessor :as_on_date

  STATES = %w(draft active deleted locked)

  belongs_to :owner, :class_name => 'User'
  has_many :items, :class_name => 'FormulationItem', :dependent => :delete_all
  has_many :constituents, :through => :items

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
    items.entries.sum(&:quantity)
  end

  def as_on(date)
    date = Time.parse(date).utc if date.is_a?(String)
    date += 1
    f = revision_at(date)
    #f.clone.tap do |g|
    f.tap do |g|
      g.as_on_date = date
      #f.items.as_on(date).each do |item|
        #g.as_on_date = date
        #item = item.revision_at(date) || item
        #tmp_item = item.clone
        #tmp_item.constituents = item.constituents.clone
        #tmp_item.formulation = g
        #g.items << tmp_item
        #g.items << item
      #end
    end
  end

  def current_items
    items.as_on(as_on_date).collect{|i| i.as_on(as_on_date)}
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
    @total_quantity ||= items.entries.sum(&:quantity)
  end

  def unit_price(currency_code = 'INR')
    constituents.as_on(as_on_date).entries.sum{|c| c.price(currency_code)}
  end

  def price_per_gram(currency_code)
    unit_price(currency_code) / net_weight
  end

  def price_per_kilogram(currency_code)
    price_per_gram(currency_code) * 1000
  end

  def current?
    @as_on_date == nil
  end

  def as_on_date
    @as_on_date ||= Time.now
  end

  private 
  def generate_code!
    update_attribute :code, "#{owner.prefix}-#{product_year}-#{id.to_s(36).upcase.rjust(5, '0')}"
  end
end
