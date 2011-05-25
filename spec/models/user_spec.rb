require 'spec_helper'

describe User do
  describe "validations" do
    #before(:each) { Factory.create :user }
    #subject { Factory.build :user }
    should_validate_presence_of :first_name, :last_name, :email
    should_validate_length_of :first_name, :last_name, :email, :maximum => 50
  end

end
