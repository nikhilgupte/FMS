class Accord < Formulation

  has_many :formulation_items, :as => :compound
  after_save :update_dependents, :if => :current_version_id_changed?

  class << self
    def import_from_csv(file)
      CSV.read(file, :headers => true).each do |row|
        params = { :origin_formula_id => row['AccordId'], :name => row['AccordName'], :product_year => (row['DateEntry'].split('-').last.to_i + 2000) }
        create_or_update(params)
      end
    end
  end

  def derivatives
    Formulation.includes(:current_version => [:items]).where(:formulation_versions => { :state => 'published', :formulation_items => { :compound_type => 'Accord', :compound_id => id } })
  end

  def derivative_versions
    FormulationVersion.includes(:items).where(:formulation_items => { :compound_type => 'Accord', :compound_id => id })
  end

  def update_dependents
    update_derivatives
    update_derivative_draft_versions
  end

  private
  def update_derivatives
    derivatives.each do |formulation|
      formulation.bump_version!(self)
    end
  end

  def update_derivative_draft_versions
    derivative_versions.drafts.each do |version|
      version.update_accord!(self)
    end
  end
end
