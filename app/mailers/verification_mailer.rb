class VerificationMailer < ApplicationMailer
  def confirm_email(verify_data)
    @verify_data = verify_data
    mail to: @verify_data.email, subject: "Confirm your #{verify_data.provider.capitalize} account"
  end
end
