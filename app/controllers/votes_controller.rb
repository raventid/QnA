class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable, only: [:create]

  def create
    @vote = Vote.new(value: params[:value], user_id: current_user.id, votable: @votable)

    if !@votable.blank? && user_signed_in? && !(current_user.id == @votable.user_id)
      if @vote.save
        render json: { vote: @vote, rating: @votable.rating }
      else
        render json: @vote.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: { message: 'You have no permission to perform this action' }, status: :forbidden
    end
  end


  def destroy
    @vote = Vote.find(params[:id])
    votable = @vote.votable
    votable_type = @vote.votable_type

    if user_signed_in? && (current_user.id == @vote.user_id)
      if @vote.destroy
        render json: { votable_id: votable.id, votable_type: votable_type, rating: votable.rating }
      else
        render json: @vote.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: { message: 'You have no permission to perform this action' }, status: :forbidden
    end
  end

  private

  def load_votable
    votable_id = params.keys.detect{ |k| k.to_s =~ /.*_id/ }
    model_klass = votable_id.chomp('_id').classify.constantize
    @votable = model_klass.find(params[votable_id])
  end
end
