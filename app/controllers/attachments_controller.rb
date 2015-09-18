class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment
  before_action :load_attachable

  authorize_resource

  respond_to :js

  def destroy
    respond_with(@attachment.destroy) if current_user.is_owner_of?(@attachable)
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
