require 'rails_helper'

RSpec.describe VerificationsController, type: :controller do

  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

  describe "POST#create" do
    before { session['devise.oauth_data'] = auth }

    context 'with valid params' do
      context 'user with specified email exists' do
        let!(:user) { create(:user) }
        let(:verification_attrs) { attributes_for(:verification, email: user.email) }

        it 'saves verification to database' do
          expect { post :create, verification: verification_attrs }.to change(Verification, :count).by(1)
        end

        it 'sends email' do
          expect { post :create, verification: verification_attrs }.to change(ActionMailer::Base.deliveries, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, verification: verification_attrs
          expect(response).to redirect_to verification_path(assigns(:verification))
        end
      end

      context 'user with specified email does not exist' do
        it 'does not save verification to datatbase' do
          expect { post :create, verification: attributes_for(:invalid_verification) }.to_not change(Verification, :count)
        end

        it 'does not send email' do
          expect { post :create, verification: attributes_for(:invalid_verification) }.to_not change(ActionMailer::Base.deliveries, :count)
        end
      end
    end

    context 'with invalid params' do
      it 'does not save verification to datatbase' do
        expect { post :create, verification: attributes_for(:invalid_verification) }.to_not change(Verification, :count)
      end

      it 'does not send email' do
        expect { post :create, verification: attributes_for(:invalid_verification) }.to_not change(ActionMailer::Base.deliveries, :count)
      end

      it 're-renders new view' do
        post :create, verification: attributes_for(:invalid_verification)
        expect(response).to render_template :new
      end
    end
  end

  describe "GET#confirm" do
    let!(:verification) { create(:verification) }
    let(:wrong_token) { SecureRandom.hex }

    context 'with valid token' do
      it 'deletes record from the database' do
        expect { get :confirm, id: verification, token: verification.token }.to change(Verification, :count).by(-1)
      end
    end

    context 'with invalid token' do
      it 'does not delete record from the database' do
        expect { get :confirm, id: verification, token: wrong_token }.to_not change(Verification, :count)
      end
    end
  end
end
