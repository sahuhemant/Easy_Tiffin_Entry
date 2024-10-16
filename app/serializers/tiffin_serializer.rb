class TiffinSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :date, :day_status, :night_status, :status_count, :customer_id
end
