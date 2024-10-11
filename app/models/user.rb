class User < ApplicationRecord
  has_many :customers
  has_many :chat_messages
  has_secure_password

  validates :user_name, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  before_create :generate_otp

  def generate_otp
    self.otp = rand(1000..9999).to_s
    self.otp_generated_at = Time.current
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "name", "number", "otp", "otp_generated_at", "otp_verified", "password_digest", "stripe_customer_id", "updated_at", "user_name"]
  end
end
