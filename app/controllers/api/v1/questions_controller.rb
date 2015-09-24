class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    respond_with Question.all
  end

  def show
    respond_with Question.find(params[:id])
  end

  def create
    respond_with current_user.questions.create(questions_params)
  end

  private

  def questions_params
    params.require(:question).permit(:title, :body)
  end
end