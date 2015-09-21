class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment
  before_action :load_attachable

  respond_to :js

  authorize_resource

  def destroy
    respond_with(@attachment.destroy)
  end

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def load_attachable
    @attachable = @attachment.attachable
  end

  # def is_owner_of?(obj)
  #   current_user.id == obj.user_id
  # end
end
