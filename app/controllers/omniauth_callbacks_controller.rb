class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :perform_oauth

  def facebook
  end

  def twitter
  end

  private

  def perform_oauth
    oauth = request.env['omniauth.auth']
    @user = User.find_for_oauth(oauth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    else
      session['devise.oauth_data'] = oauth.slice('provider', 'uid')
      redirect_to new_verification_path
    end
  end
end
