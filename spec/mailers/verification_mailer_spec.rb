require "rails_helper"

RSpec.describe VerificationMailer, type: :mailer do
  describe '#confirm_email' do
    let(:verification) { create(:verification) }
    let!(:email) { VerificationMailer.confirm_email(verification) }

    it 'should send mail to email that needs to be verified' do
      expect(email).to be_delivered_to(verification.email)
    end

    it 'should have subject with provider name' do
      expect(email).to have_subject("Confirm your #{verification.provider.capitalize} account")
    end
  end
end
