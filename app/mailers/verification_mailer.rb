class VerificationMailer < ApplicationMailer
  def confirm_email(verification_data)
    @verification_data = verification_data
    mail to: @verification_data.email, subject: "Confirm your #{@verification_data.provider.capitalize} account"
  end
end
