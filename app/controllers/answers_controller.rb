class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:best, :destroy, :update]

  respond_to :js

  def create
    respond_with(@answer = @question.answers.new(answer_params.merge(user: current_user)))
  end

  def update
    if @answer.user == current_user
     flash[:notice] =  @answer.update(answer_params) ? 'Answer has been updated' : 'Can not update answer'
    end
  end

  def destroy
    if @answer.user == current_user
      flash[:notice] = 'Your answer has been deleted' if @answer.destroy  
    else
      flash[:alert] = 'Can not delete the answer.'
    end 
  end

  def best
    if @answer.question.user == current_user
      @answer.best_answer
      flash[:notice] = 'Best answer has been choosen'
    end
  end 

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question_answer
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy])
  end
end
