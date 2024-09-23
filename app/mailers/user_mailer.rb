class UserMailer < ApplicationMailer
  default from: 'sahuhemant360@gmail.com' # Change this to your sender email

  def otp_email(user, otp)
    @user = user
    @otp = otp

    mail(to: @user.email, subject: 'Your OTP Code')
  end
end
