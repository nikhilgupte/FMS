require 'csv'
class Formulation < ActiveRecord::Base

  acts_as_audited

  belongs_to :owner, :class_name => 'User'
  belongs_to :current_version, :class_name => 'FormulationVersion'
  has_many :versions, :class_name => 'FormulationVersion'
  has_one :draft_version, :class_name => 'FormulationVersion', :conditions => { :state => 'draft' }

  validates :product_year, :presence => true
  validates :origin_formula_id, :uniqueness => { :case_insensitive => true }, :allow_blank => true

  delegate :name, :state, :published?, :published_at, :constituents, :items, :net_weight, :unit_price, :net_weight, :to => :current_version

  before_create :generate_code!

  default_value_for :product_year, Time.now.year

  accepts_nested_attributes_for :draft_version
  accepts_nested_attributes_for :versions

  scope :with_name_or_code, lambda { |term| where({ :code.like => "%#{term}%" } | { :current_version => { :name.like => "%#{term}%" } }).where(:current_version => { :state => 'published' }).joins(:current_version) }

  def to_s
    "#{name} (##{code} / #{current_version.version_number})"
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

  def create_draft_version
    raise "Draft version already exists!" if draft_version.present?
    draft_version = current_version.build_copy
    draft_version.audit_comment = "New version created"
    FormulationItem.without_auditing do
      draft_version.save!
    end
    self.reload
    draft_version
  end

  def bump_version!(accord)
    new_version = current_version.build_copy
    new_version.audit_comment = "Updated Accord - #{accord}"
    FormulationItem.without_auditing do
      new_version.publish!
    end
  end

  private 
  def associate_current_version
    self.current_version = draft_version
    save!
  end

  def generate_code!
    #update_attribute :code, "#{owner.prefix}-#{product_year}-#{Time.now.to_i.to_s(36).upcase.rjust(5, '0')}"
    self.code = "#{owner.prefix}-#{product_year}-#{Time.now.to_i.to_s(36).upcase.rjust(5, '0')}"
  end
end
