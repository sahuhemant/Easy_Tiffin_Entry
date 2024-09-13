class Tiffin < ApplicationRecord
  belongs_to :customer
  enum status: { no: 0, yes: 1 }
end
