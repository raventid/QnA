class OmniauthCallbacksController < ApplicationController
  before_action :sign_in_via_oauth, only: [:facebook]

  def facebook
  end

  def input_email
    @user = User.generate_user(email_params[:email])
    @user.authorizations.create(provider: session['device.auth_provider'], uid: session['device.auth_uid'])
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
  end

  private

  def sign_in_via_oauth
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    else
      render 'omniauth_callback/input_email'
      session['device.auth_provider'] = auth.provider
      session['device.auth_uid'] = auth.uid
    end
  end


  def email_params
    params.require(:user).permit(:email)
  end

end
