class AddTwoFactorToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :otp, :string
    add_column :users, :otp_generated_at, :datetime
    add_column :users, :otp_verified, :boolean, default: false
  end
end
