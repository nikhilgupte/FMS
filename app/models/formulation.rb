require 'csv'
class Formulation < ActiveRecord::Base

  STATES = %w(draft active deleted locked)
  belongs_to :owner, :class_name => 'User'
  has_many :items, :class_name => 'FormulationItem', :dependent => :delete_all

  validates :name, :product_year, :presence => true
  validates :state, :inclusion => STATES

  after_create :generate_code!

  default_value_for :state, "draft"

  accepts_nested_attributes_for :items

  def to_s
    "#{name} (##{code})"
  end

  class << self
    def import_from_csv(file)
      CSV.read(file, :headers => true).each do |row|
        params = { :origin_formula_id => row['FragranceId'], :name => row['FragranceName'], :product_year => (row['DateEntry'].split('-').last.to_i + 2000) }
        create_or_update(params)
      end
    end

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
    items.sum(:quantity)
  end

  private 
  def generate_code!
    update_attribute :code, "#{owner.prefix}-#{product_year}-#{id.to_s(36).upcase.rjust(5, '0')}"
  end
end
