class Customer < ApplicationRecord
  belongs_to :user
  has_many :tiffins
  enum payment_status: { no: 0, yes: 1 }
end
