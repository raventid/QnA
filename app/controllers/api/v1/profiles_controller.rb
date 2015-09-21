class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!
  authorize_resource class: false

  respond_to :json

  def show
    respond_with User.where.not(id: current_resource_owner.id)
  end

  def me
    respond_with current_resource_owner
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # For CanCanCan authorization
  alias_method :current_user, :current_resource_owner
end