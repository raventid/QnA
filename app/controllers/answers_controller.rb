class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:best, :destroy, :update]

  authorize_resource
  respond_to :js

  def create
     respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    respond_with(@answer.update(answer_params))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def best
    respond_with(@answer.best_answer)
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
