class AddColumnInCustomerTable < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :amount_paid, :integer
    add_column :customers, :amount_due, :integer
    add_column :customers, :payment_status, :integer
  end
end
