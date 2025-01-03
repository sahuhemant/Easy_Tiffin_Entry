class AddAuthenticationTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :number, :integer
    add_column :users, :stripe_customer_id, :string
    add_column :users, :email, :string
  end
end
