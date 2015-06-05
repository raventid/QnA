require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer)   { create(:answer) }
  let(:answer_of_user) { create(:answer, user: user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves answer in database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'assigns answer with current user' do
        post :create, question_id: question, answer: attributes_for(:answer)
        assigning_answer = assigns(:answer)  
        expect(assigning_answer.user_id).to eq subject.current_user.id
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

  describe 'DELETE #destroy' do
    context 'User is owner of the Answer and can delete it' do
      it 'user tries to delete answer' do
        sign_in(user)
        expect{ delete :destroy, id: answer_of_user }.to change(answer_of_user.question.answers, :count).by(-1)
      end

      it 'redirect to question path' do
        sign_in(user)
        delete :destroy, id: answer_of_user 
        expect(response).to redirect_to question_path(answer_of_user.question_id) 
      end
    end
   
    context 'User is NOT the owner of the Answer and can not delete it'
      it 'User is NOT owner of the Answer, and can not delete him' do
        sign_in(another_user)
        expect{ delete :destroy, id: answer_of_user }.to_not change(answer_of_user.question.answers, :count)
      end

      it 'redirect to question path' do
        sign_in(another_user)
        delete :destroy, id: answer_of_user 
        expect(response).to redirect_to question_path(answer_of_user.question_id) 
      end
  end
end
