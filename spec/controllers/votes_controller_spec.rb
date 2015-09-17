require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user)  { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer)   { create(:answer, question: question, user: user)}

    describe "POST #create" do

      context "user can vote up and value of vote equal 1" do

        it "for the question" do
          sign_in another_user
          expect {post :create, question_id: question.id, value: 1, format: :json}.to change(Vote, :count).by(1)
        end

        it "send OK to client from server" do
           sign_in another_user
           post :create, question_id: question.id, value: 1, format: :json
           expect(response).to have_http_status(200)
        end
      end

    context "unregistered user" do

      it "try to vote up" do
        expect {post :create, question_id: question.id, value: 1, format: :json}.to_not change(Vote, :count)
      end

      it "send 401 to client from server" do
          post :create, question_id: question.id, value: 1, format: :json
          expect(response).to have_http_status(401)
      end
    end

    context "author can not vote up for your questions or answers" do

      before do
        sign_in(user)
      end

      it "author can not do it" do
        expect {post :create, question_id: question.id, value: -1, format: :json}.to_not change(Vote, :count)
      end

      it "send 403 to client from server" do
        post :create, question_id: question.id, value: -1, format: :json
        expect(response).to have_http_status(403)
      end
    end
  end


  describe "POST #destroy" do
        let(:owner){ create(:user)}
        let(:user){ create(:user)}
        let(:answer){ create(:answer, user: owner)}
        let!(:vote){ create(:answer_vote, votable: answer, user: user, value: -1) }

        context "user can cancel the vote" do
          it "destroy vote" do
            sign_in (user)
            expect{ delete :destroy, id: vote.id, format: :json }.to change(Vote, :count).by(-1)
            answer.reload
            expect(answer.rating).to eq 0
          end

          it "send OK to client from server" do
            sign_in (user)
            delete :destroy, id: vote.id, format: :json
            expect(response).to have_http_status(200)
          end
        end

        context "unregistered user" do
          it "destroy vote" do
            expect{ delete :destroy, id: vote.id, format: :json }.to_not change(Vote, :count)
            answer.reload
            expect(answer.rating).to eq 0
          end

          it "send 401 to client from server" do
            delete :destroy, id: vote.id, format: :json
            expect(response).to have_http_status(401)
          end
        end

        context "author can not vote cancel for his questions or answers" do

          before do
            sign_in(owner)
          end

          it "author can not do it" do
            expect {delete :destroy, id: vote.id, format: :json}.to_not change(Vote, :count)
          end

          it "send 403 to client from server" do
            delete :destroy, id: vote.id, format: :json
            expect(response).to have_http_status(403)
          end
        end
  end

end
