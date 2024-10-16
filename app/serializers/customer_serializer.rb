class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :mobile_no, :address, :amount_paid, :amount_due, :payment_status, :user_id
end
