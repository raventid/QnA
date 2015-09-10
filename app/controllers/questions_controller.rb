# Question Controller
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  after_action :publish_question, only: [:create]

  respond_to :js, only: [:update]

  def index
    # @questions = Question.all
    respond_with(@questions = Question.all)
  end

  def show
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    # @question = Question.create(question_params)
    # @question.user = current_user
    # if @question.save
    #   flash[:notice] = "Your question successfully created."
    #   redirect_to @question
    # else
    #   render :new
    # end
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    respond_with(@question.update(question_params))
  end

  def destroy
    if @question.user == current_user
      respond_with(@question.destroy)
    else
      flash[:notice] = 'You are not the owner of this question.'
      render :show
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def publish_question
    # we publish message to channel only if we are sure it is correct
    PrivatePub.publish_to('/questions', question: @question.to_json) if @question.valid?
  end

  # def interpolation_options
  #   # send any text to flash messages with interpolation options
  #   { resource_name: @question.user.email }
  # end
end
