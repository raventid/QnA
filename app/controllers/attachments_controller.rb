class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachable = @attachment.attachable
    if is_owner_of?(@attachable)
      flash[:notice] = @attachment.destroy ? 'File deleted successfully.' : 'File can\'t be deleted.'
    else
      flash[:notice] = 'File can\'t be deleted because you are not owner'
    end
  end

  def is_owner_of?(obj)
    user_signed_in? && current_user.id == obj.user_id
  end
end
