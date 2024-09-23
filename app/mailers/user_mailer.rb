class UserMailer < ApplicationMailer
  default from: 'sahuhemant360@gmail.com' # Change this to your sender email

  def otp_email
    @user = params[:user]
    @otp = params[:otp] # Retrieve the OTP from parameters

    mail(to: @user.email, subject: 'Your OTP Code')
  end
end
