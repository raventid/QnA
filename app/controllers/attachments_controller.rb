class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment
  before_action :load_attachable

  respond_to :js

  def destroy
    respond_with(@attachment.destroy) if is_owner_of?(@attachable)
  end

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def load_attachable
    @attachable = @attachment.attachable
  end

  def is_owner_of?(obj)
    user_signed_in? && current_user.id == obj.user_id
  end

end
