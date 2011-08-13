module SoftDeletable
  def self.included(base)
    base.class_eval do
      scope :available, where(:deleted_at => nil)
      scope :deleted, where("deleted_at is not NULL")
      scope :as_on, lambda { |date| where(:created_at.lte => date).where({ :deleted_at => nil } | { :deleted_at.gt => date }) }
      scope :current, lambda {  as_on(Time.now) }
    end

    def deleted?
      deleted_at.present?
    end

    def destroy
      soft_delete!
    end

    def soft_delete!
      update_attribute :deleted_at, Time.now.utc
    end
  end
end
