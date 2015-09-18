class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable, only: [:create]

  authorize_resource

  def create
    @vote = Vote.new(value: params[:value], user: current_user, votable: @votable)

    if @vote.save
      render json: { vote: @vote, rating: @votable.rating }
    else
      render json: @vote.errors.full_messages, status: :unprocessable_entity
    end
  end


  def destroy
    @vote = Vote.find(params[:id])
    votable = @vote.votable
    votable_type = @vote.votable_type

    authorize! :destroy, @vote
    if @vote.destroy
      render json: { votable_id: votable.id, votable_type: votable_type, rating: votable.rating }
    else
      render json: @vote.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def load_votable
    votable_id = params.keys.detect{ |k| k.to_s =~ /.*_id/ }
    model_klass = votable_id.chomp('_id').classify.constantize
    @votable = model_klass.find(params[votable_id])
    authorize! action_name.to_sym, @votable
  end
end
