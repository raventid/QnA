require_relative '../api_helper'

describe 'Answers API' do
  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }

  describe 'GET /questions/:question_id/answers' do
    let(:method) { :get }
    let(:path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:answers) { create_pair(:answer, question: question) }
      let(:first_answer) { answers.first }

      before { json_request(method, path, access_token: access_token.token) }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(first_answer.send(attr.to_sym).to_json)
                                       .at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /questions/:question_id/answers/:answer_id' do
    let!(:answer) { create(:answer) }
    let(:method) { :get }
    let(:path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:attach) { create(:attachment, attachable: answer) }
      let!(:comment) { create(:comment, commentable: answer, commentable_type: 'Answer') }

      before { json_request(method, path, access_token: access_token.token) }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json)
                                       .at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path('answer/comments')
        end

        %w(id comment_body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
                                         .at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attach.file.url.to_json)
                                       .at_path('answer/attachments/0/url')
        end
      end
    end
  end

  describe 'POST /questions/:question_id/answers' do
    let(:current_user) { User.find(access_token.resource_owner_id) }
    let(:method) { :post }
    let(:path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:request) do
          json_request(
              method, path, answer: attributes_for(:answer), access_token: access_token.token
          )
        end

        it 'returns status 201' do
          request
          expect(response).to have_http_status :created
        end

        it 'saves answer in database with assigning to question' do
          expect { request }.to change(question.answers, :count).by(1)
        end

        it 'assigns created answer to current user' do
          expect { request }.to change(current_user.answers, :count).by(1)
        end
      end

      context 'witn invalid attributes' do
        let(:invalid_params_request) do
          json_request(
              method, path, answer: attributes_for(:invalid_answer), access_token: access_token.token
          )
        end

        it 'returns status 422' do
          invalid_params_request
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'does not save answer in database' do
          expect { invalid_params_request }.to_not change(Answer, :count)
        end
      end
    end
  end
end