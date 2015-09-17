require 'rails_helper'

RSpec.describe Verification, type: :model do
  it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
    it { should validate_presence_of :email }
    it do
      should validate_uniqueness_of(:email).scoped_to(:provider)
             .with_message("We've already sent you mail. Please check your inbox.")
    end

  describe '#oauth_hash' do
    let!(:verification) { create(:verification) }

    it 'returns oauth hash with object parameters' do
      oauth = verification.oauth_hash
      expect(oauth.uid).to eq verification.uid
      expect(oauth.provider).to eq verification.provider
      expect(oauth.info.email).to eq verification.email
    end
  end
end
