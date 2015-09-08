class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = Comment.new(commentable: @commentable, user_id: current_user.id,
                           comment_body: comment_params[:comment_body])
    @question = @comment.commentable_type == 'Question' ? @comment.commentable : @comment.commentable.question
    @comment.save
  end

  private

  def load_commentable
    commentable_id = params.keys.detect{ |k| k.to_s =~ /.*_id/ }
    model_klass = commentable_id.chomp('_id').classify.constantize
    @commentable = model_klass.find(params[commentable_id])
  end

  def comment_params
    params.require(:comment).permit(:comment_body)
  end
end
