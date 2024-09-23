class AddTwoFactorToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :otp_secret, :string
    add_column :users, :otp_required_for_login, :boolean
  end
end
