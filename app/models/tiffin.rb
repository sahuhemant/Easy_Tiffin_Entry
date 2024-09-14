class Tiffin < ApplicationRecord
  belongs_to :customer
  before_save :calculate_status_count
  enum day_status: [:yes, :no]
  enum night_status: [:right, :wrong]

  private

    def calculate_status_count
      self.status_count = if day_status == 'yes' && night_status == 'right'
                            2
                          elsif day_status == 'yes' || night_status == 'right'
                            1
                          else
                            0
                          end
    end
end
