class User < ActiveRecord::Base
  acts_as_audited :except => [:current_login_at, :last_login_at, :current_login_ip, :last_login_ip, :password_salt, :crypted_password, :persistence_token, :single_access_token, :perishable_token]

  validates :first_name, :last_name, :presence => true, :length => { :maximum => 50 }
  validates :email, :presence => true, :length => { :maximum => 50 }, :uniqueness => { :case_sensitive => false }

  has_many :fragrances, :foreign_key => 'owner_id'
  has_many :accords, :foreign_key => 'owner_id'

  scope :with_prefix, lambda{|prefix| where(["prefix like ?", "#{prefix.downcase}%"]) }

  before_create :generate_prefix

  default_value_for :time_zone, "Mumbai"

  acts_as_authentic do |c|
    #c.my_config_option = my_value
    c.login_field = 'email'
  end

  def name
    "#{first_name} #{last_name}"
  end

  def to_s
    name
  end

  private
  def generate_prefix
    prefix = "#{first_name[0]}#{last_name[0]}".upcase
    count = User.with_prefix(prefix).count
    self.prefix = "#{prefix}#{count}"
  end
end
