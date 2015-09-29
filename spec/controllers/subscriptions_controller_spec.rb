require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user)          { create(:user) }
  let!(:user2)         { create(:user) }
  let!(:question)      { create(:question, user: user) }
  let!(:subscription)  { user.subscriptions.where(question: question).first }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { sign_in(user) }
      before { post :create, question_id: question, user_id: user, format: :js }
      # it 'subscription assigns to user and question' do
      #   expect(assigns(:subscription).user_id).to eq subject.current_user.id
      # end
      it 'save associated subscription' do
        expect{ post :create, question: question, user: user2, format: :js }.to change(Subscription, :count).by(1)
      end
      it 'render create template' do
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid attributes' do
      it 'deletes answer' do
        sign_in(user)
        expect { delete :destroy, id: subscription.id, format: :js }.to change(Subscription, :count).by(-1)
      end
      it 'user cant delete another user answer' do
        sign_in(user2)
        expect { delete :destroy, id: subscription.id, format: :js }.to_not change(Subscription, :count)
      end
    end
  end
end
