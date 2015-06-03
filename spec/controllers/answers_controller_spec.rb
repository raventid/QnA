require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }
  let(:answer)   { create(:answer, question: question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves answer in database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'without valid attributes' do
      it 'does not save answer in database' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 're-render question with answers' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
