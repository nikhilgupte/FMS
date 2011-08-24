class FormulationVersion < ActiveRecord::Base

  acts_as_audited
  has_associated_audits

  STATES = %w(draft published)

  delegate :code, :owner, :product_year, :origin_formula_id, :to => :formulation

  belongs_to :formulation, :counter_cache => :versions_count
  has_many :items, :class_name => 'FormulationItem', :dependent => :delete_all
  has_many :constituents, :through => :items

  accepts_nested_attributes_for :items, :reject_if => Proc.new{ |o| %w(compound_id quantity).all?{|f| o[f].blank?} }, :allow_destroy => true

  attr_protected :published_at, :state, :formulation_id

  validates :name, :presence => true
  validates :state, :inclusion => STATES

  default_value_for :state, "draft"

  before_create :generate_version_number
  after_create :make_current_version!, :if => Proc.new { |v| v.formulation.versions.count == 1 }

  default_scope order('formulation_versions.id desc')
  scope :drafts, where(:state => 'draft')

  def net_weight
    items.current.sum(:quantity)
  end

  def total_quantity
    items.current.sum(:quantity)
  end

  def unit_price(currency_code = 'INR')
    #constituents.current.entries.sum{|c| c.price(currency_code)}
    constituents.price(Date.today, currency_code).to_f
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

  def published?
    state == 'published'
  end

  def publish!
    transaction do
      self.state = 'published'
      self.published_at = Time.now
      self.audit_comment = "Published" unless self.audit_comment.present?
      save!
      make_current_version!
    end
  end

  def make_current_version!
    formulation.current_version = self
    formulation.save!
  end

  def changes
    (audits + associated_audits).sort_by(&:created_at).reverse
  end

  def to_s
    version_number
  end

  def update_accord!(accord)
    items.current.accords.where(:compound_id => accord.id).each &:explode!
    self.version_updated_at = Time.now
    self.audit_comment = "Updated Accord - #{accord}"
    save!
  end

  def build_copy
    copy = formulation.versions.build self.attributes
    items.current.each{|i| copy.items.build i.attributes}
    copy
  end

  private

  def generate_version_number
    self.version_number = "#{Time.now.year}#{Time.now.month.to_s.rjust(2,"0")}-#{formulation.versions_count + 1}"
  end
end
