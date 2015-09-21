class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable
  before_action :load_question

  authorize_resource
  respond_to :js

  def create
    respond_with(@comment = current_user.comments.create(commentable:  @commentable,
                                                         comment_body: comment_params[:comment_body]))
  end

  private

  def load_commentable
    commentable_id = params.keys.detect{ |k| k.to_s =~ /.*_id/ }
    model_klass = commentable_id.chomp('_id').classify.constantize
    @commentable = model_klass.find(params[commentable_id])
  end

  def load_question
     @question = @commentable.is_a?(Question) ? @commentable : @commentable.question
  end

  # def publish_comment
  # end

  def comment_params
    params.require(:comment).permit(:comment_body)
  end
end
