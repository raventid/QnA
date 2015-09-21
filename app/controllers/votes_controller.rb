class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable, only: [:create]
  before_action :load_vote, only: [:destroy]

  authorize_resource except: :create

  def create
    @vote = Vote.new(value: params[:value], user: current_user, votable: @votable)
    authorize! :create, @vote
    if @vote.save
      render json: { vote: @vote, rating: @votable.rating }
    else
      render json: @vote.errors.full_messages, status: :unprocessable_entity
    end
  end


  def destroy
    votable = @vote.votable
    votable_type = @vote.votable_type

    if @vote.destroy
      render json: { votable_id: votable.id, votable_type: votable_type, rating: votable.rating }
    else
      render json: @vote.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def load_vote
    @vote = Vote.find(params[:id])
  end

  def load_votable
    votable_id = params.keys.detect{ |k| k.to_s =~ /.*_id/ }
    model_klass = votable_id.chomp('_id').classify.constantize
    @votable = model_klass.find(params[votable_id])
  end
end
