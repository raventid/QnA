class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  respond_to :js
  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    respond_with @subscription = current_user.subscriptions.create(question: @question)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @question = @subscription.question
    respond_with @subscription.destroy
  end
end