class Customer < ApplicationRecord
  belongs_to :user
  has_many :tiffins
  enum payment_status: { completed: 0, pending: 1 }
end
