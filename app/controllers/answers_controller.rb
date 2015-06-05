class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Your answer has been added! Thank you!'
      redirect_to @question
    else
      flash[:notice] = 'Can not create answer.'
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if @answer.user == current_user
      flash[:notice] = @answer.destroy ? 'Your answer has been deleted' : 'Can not delete the answer.'
    else
      flash[:notice] ='You are not the owner of this answer.'
    end
    redirect_to question_path(@question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
