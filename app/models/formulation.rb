require 'csv'
class Formulation < ActiveRecord::Base

  acts_as_audited

  belongs_to :owner, :class_name => 'User'
  belongs_to :current_version, :class_name => 'FormulationVersion'
  has_many :versions, :class_name => 'FormulationVersion'
  has_one :draft_version, :class_name => 'FormulationVersion', :conditions => { :state => 'draft' }

  validates :product_year, :presence => true
  validates :origin_formula_id, :uniqueness => { :case_insensitive => true }, :allow_blank => true

  delegate :name, :state, :to => :current_version

  #after_create :associate_current_version
  before_create :generate_code!

  default_value_for :product_year, Time.now.year

  accepts_nested_attributes_for :draft_version
  accepts_nested_attributes_for :versions

  def to_s
    "#{name} (##{code})"
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

  def build_draft
    draft = build_draft_version(current_version.attributes)
    current_version.items.current.each{|i| draft.items.build i.attributes}
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
