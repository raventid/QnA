require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do
    respond_to do |format|
      format.html { redirect_to root_url, alert: "You're not allowed to perform this action" }
      format.any(:json, :js) { render nothing: true, status: :forbidden }
    end
  end
end
