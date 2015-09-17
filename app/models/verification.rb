class Verification < ActiveRecord::Base
  validates :uid, :provider, :token, presence: true
  validates :email, presence: true, email: true,
            uniqueness: {
                scope: :provider,
                message: "We've already sent you mail. Please check your inbox."
            }

  before_validation { self.token ||= SecureRandom.hex }

  def oauth_hash
    OmniAuth::AuthHash.new(provider: provider,
                           uid: uid,
                           info: {
                               email: email
                           })
  end
end
