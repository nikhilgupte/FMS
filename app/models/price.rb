class Price < ActiveRecord::Base

  belongs_to :pirceable, :polymorphic => true
  belongs_to :currency
end
