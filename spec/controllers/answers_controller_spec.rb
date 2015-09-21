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
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 'assigns answer with current user' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        assigning_answer = assigns(:answer)
        expect(assigning_answer.user_id).to eq subject.current_user.id
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'without valid attributes' do
      it 'does not save answer in database' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end


  describe 'PATCH #update' do

    sign_in_user

    before { answer.update!(user: @user) }

    context 'with valid attributes' do

      it 'update answer in database' do
        patch :update, question_id: question, id: answer, answer: { body: 'TestTest' }, format: :js
        answer.reload
        expect(answer.body).to eq 'TestTest'
      end

      it 'render template answers/update' do
        patch :update, question_id: question, id: answer, answer: { body: 'TestTest' }, format: :js
        expect(response).to render_template 'answers/update'
      end

    end

    context 'without valid attributes' do

      it 'update answer in database' do
        patch :update, question_id: question, id: answer, answer: attributes_for(:invalid_answer), format: :js
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 'render template answers/update' do
        patch :update, question_id: question, id: answer, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'POST #best' do
    sign_in_user

    context 'Author checks best answer' do

      before { question.update!(user: @user) }
      before { answer.update!(question: question) }

      it 'render template answers/best' do
        post :best, question: question, id: answer, answer: { best: true }, format: :js
        expect(response).to render_template :best
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'User is owner of the Answer and can delete it' do
      it 'user tries to delete answer' do
        sign_in(user)
        expect{ delete :destroy, id: answer_of_user, format: :js }.to change(answer_of_user.question.answers, :count).by(-1)
      end

      it 'render template answers/destroy' do
	sign_in(user)
        delete :destroy, id: answer_of_user, format: :js
        expect(response).to render_template :destroy
      end

    context 'User is NOT the owner of the Answer and can not delete it'
      it 'User is NOT owner of the Answer, and can not delete him' do
        sign_in(another_user)
        expect{ delete :destroy, id: answer_of_user, format: :js }.to_not change(answer_of_user.question.answers, :count)
      end
    end
  end
end
