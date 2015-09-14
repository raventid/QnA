module AcceptanceHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def auth_with(provider, email = nil)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({provider: provider.to_s,
                                                                  uid: '12345',
                                                                  info: {
                                                                      name: 'David Hansson',
                                                                      email: (email if email)
                                                                  }
                                                                 })
  end
end