module SoftDeletable
  def self.included(base)
    base.class_eval do
      scope :available, where(:deleted_at => nil)
      scope :deleted_at, where("deleted_at is not NULL")
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
