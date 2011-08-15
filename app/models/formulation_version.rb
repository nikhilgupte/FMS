class FormulationVersion < ActiveRecord::Base

  acts_as_audited
  has_associated_audits

  STATES = %w(draft published)

  delegate :owner, :product_year, :origin_formula_id, :to => :formulation

  belongs_to :formulation, :counter_cache => :versions_count
  has_many :items, :class_name => 'FormulationItem', :dependent => :delete_all
  has_many :constituents, :through => :items

  accepts_nested_attributes_for :items, :reject_if => Proc.new{ |o| %w(compound_id quantity).all?{|f| o[f].blank?} }, :allow_destroy => true

  validates :name, :presence => true
  validates :state, :inclusion => STATES

  default_value_for :state, "draft"

  before_save :generate_version_number
  after_create :make_current_version!, :if => Proc.new { |v| v.formulation.versions.count == 1 }

  def net_weight
    items.current.sum(:quantity)
  end

  def total_quantity
    items.current.sum(:quantity)
  end

  def unit_price(currency_code = 'INR')
    constituents.current.entries.sum{|c| c.price(currency_code)}
  end

  def price_per_gram(currency_code)
    unit_price(currency_code) / net_weight
  end

  def price_per_kilogram(currency_code)
    price_per_gram(currency_code) * 1000
  end

  def current?
    formulation.current_version == self
  end

  def init
    3.times{ items.build }
    self
  end

  def draft?
    state == 'draft'
  end

  def publish!
    self.state = 'published'
    save!
    make_current_version!
  end

  def make_current_version!
    formulation.current_version = self
    formulation.save!
  end

  private


  def generate_version_number
    self.version_number = "#{Time.now.year}#{Time.now.month.to_s.rjust(2,"0")}-#{formulation.versions_count + 1}"
  end
end