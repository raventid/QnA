class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:best, :destroy, :update]

  respond_to :js

  def create
    # we use @question.answers.create instead of build or new because we have to save this in db
     respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    respond_with(@answer.update(answer_params)) if @answer.user_id == current_user.id
  end

  def destroy
    respond_with(@answer.destroy) if @answer.user_id == current_user.id
  end

  def best
    respond_with(@answer.best_answer) if @answer.question.user_id == current_user.id
  end 

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy])
  end
end
