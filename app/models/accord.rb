class Accord < Formulation

  scope :with_name_or_code, lambda { |term| where("name ILIKE :name OR lower(code) ILIKE :code", { :name => "%#{term}%", :code => "#{term}%" }) }

  class << self
    def import_from_csv(file)
      CSV.read(file, :headers => true).each do |row|
        params = { :origin_formula_id => row['AccordId'], :name => row['AccordName'], :product_year => (row['DateEntry'].split('-').last.to_i + 2000) }
        create_or_update(params)
      end
    end
  end

end
