require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:question) { create(:question) }


    describe 'GET #index' do

      before { get :index }
      let(:questions) { create_list(:question, 2) }

      it 'get an array of all questions' do

        expect(assigns(:questions)).to match_array(questions)
      end
      it { should render_template :index }
    end


    describe 'GET #show' do
      before { get :show, id: question }

      it 'get one question by id' do
        expect(assigns(:question)).to eq question
      end

      # 'gem cocoon' will generate attachment by clicking on button, so we don't need to create attachment by hand
      # it 'builds new attachment for answer' do
      #   expect(assigns(:new_answer).attachments.first).to be_a_new(Attachment) 
      # end

      it { should render_template :show }
    end


    describe 'GET #new' do
      sign_in_user

      before { get :new }

      it 'get a new question object' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      # 'gem cocoon' will generate attachment by clicking on button, so we don't need to create attachment by hand for question too
      # it 'builds new attachment for question' do
      #    expect(assigns(:question).attachments.first).to be_a_new(Attachment)
      # end

      it { should render_template :new }
    end


    #describe 'GET #edit' do
    #  sign_in_user

    #  before { get :edit, id: question }

    #  it 'get a question by id for edit' do
    #    expect(assigns(:question)).to eq question
    #  end

    #  it { should render_template 'edit' }
    #end

    describe 'POST #create' do
      
    let(:user){ create(:user) }

    context 'Authenticated user try create question with valid attributes' do
      before { sign_in(user) }
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'assigns the question with current user' do
        post :create, question: attributes_for(:question)
        question = assigns(:question)
        expect(question.user_id).to eq user.id
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'Authenticated user try create question with invalid attributes' do
      before { sign_in(user) }
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
    context 'Non-authenticated user try create question' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
    end
    end

    describe 'PATCH #update' do
      let(:user){ create(:user) }
      let!(:question) { create(:question, user: user) }

      before { sign_in user }

      context 'valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, id: question, question: attributes_for(:question), format: :js
          expect(assigns(:question)).to eq question
        end

        it 'change question attribute' do
          patch :update, id: question, question: { body: 'New Body' }, format: :js
          question.reload
          #expect(question.title).to eq 'New Title'
          expect(question.body).to eq 'New Body'
        end

        it 'render template questions/update' do
          patch :update, id: question, question: attributes_for(:question), format: :js
          expect(response).to render_template :update
        end
      #   check for authorized user
      end

      context 'not valid attibutes' do
        it 'it does not update the question' do
          patch :update, id: question, question: attributes_for(:invalid_question), format: :js
          question.reload
          expect(question.title).to eq 'QuestionFactoryGirlTitle'
          expect(question.body).to eq 'QuestionFactoryGirlText'
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:first_user){ create(:user) }
      let(:second_user){ create(:user) }
      let!(:question) { create(:question, user: first_user) }
  
      it 'Authencticated user is owner of question' do
        sign_in(first_user)
        expect{ delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        sign_in(first_user)
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
  
      it 'Authencticated user is not owner of question' do
        sign_in(second_user)
        expect{ delete :destroy, id: question }.to_not change(Question, :count)
      end

      # sign_in_user
      
      # before { question } #other way we will get .by(-1)

      # it 'delete question' do
      #   expect { delete :destroy, id: question }.to change(Question, :count).by(-1) #check that we really deleted this question
      # end

      # it 'redirect to index view' do
      #   delete :destroy, id: question
      #   expect(response).to redirect_to questions_path
      # end
    end

end
