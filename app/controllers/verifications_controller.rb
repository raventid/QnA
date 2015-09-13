class VerificationsController < ApplicationController
  before_action :permit_access, except: :confirm
  before_action :prepare_oauth, only: :create
  before_action :find_verification, only: :confirm

  def new
    @verification = Verification.new
  end

  def create
    @verification = Verification.new(verifications_params.merge(uid: @oauth.uid, provider: @oauth.provider))
    if @verification.valid?
      try_auth_user
    else
      render :new
    end
  end

  def show
    flush_oauth
  end

  def confirm
    user = User.find_for_oauth(@verification.oauth_hash)
    return unless user
    @verification.destroy if @verification.persisted?
    flash.notice = "Successfully authenticated from #{@verification.provider.capitalize} account"
    sign_in_and_redirect user, event: :authentication
  end

  private

  def permit_access
    redirect_to root_path unless session['devise.oauth_data']
  end

  def prepare_oauth
    @oauth = OmniAuth::AuthHash.new(session['devise.oauth_data'])
  end

  def try_auth_user
    if User.exists?(email: @verification.email)
      @verification.save
      VerificationMailer.confirm_email(@verification).deliver_now
      redirect_to verification_path(@verification)
    else
      confirm
    end
  end

  def flush_oauth
    session['devise.oauth_data'] = nil if session['devise.oauth_data']
  end

  def find_verification
    @verification = Verification.find_by_id(params[:id])
    redirect_to root_path unless @verification.present? && @verification.token == params[:token]
  end

  def verifications_params
    params.require(:verification).permit(:email)
  end
end
