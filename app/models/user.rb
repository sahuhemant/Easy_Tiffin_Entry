class User < ApplicationRecord
  has_many :customers
  has_secure_password

  validates :user_name, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  before_create :generate_otp

  def generate_otp
    self.otp = rand(1000..9999).to_s
    self.otp_generated_at = Time.current
  end
end
