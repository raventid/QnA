module OmniauthMacros

  def mock_auth_hash_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({'provider' => 'facebook',
                                                                   'uid'      => '123456',
                                                                   'info'     => {
                                                                       'facebook' => 'test@facebook.com',
                                                                       'name'     => 'mockuser'
                                                                   }})
  end
end