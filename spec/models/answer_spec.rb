require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
 
  it { should have_many(:attachments).dependent(:destroy) } 
  it { should belong_to :question }
  it { should belong_to :user }

  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:another_answer) { create(:answer, question: question) }

  describe '#best_answer' do

   it 'marks answer as best, question does not have best answer' do

     answer.best_answer

     expect(answer.best).to be true

    end

    it 'marks answer as best, question already has best answer' do
      another_answer.update!(best: true)

      answer.best_answer
      another_answer.reload

      expect(answer.best).to be true
      expect(another_answer.best).to be false

    end
  end

  # describe '#create_subscription_for_author' do
  #   let(:user) { create(:user) }
  #   let(:answer) { create(:answer) }
  #
  #   it 'should return subscription if it exist' do
  #     expect(answer.create_subscription_for_author(user, answer.question)).to be_a Subscription
  #   end
  #   it 'should create new subscription if it does not exist' do
  #     expect(answer.create_subscription_for_author(user, answer.question)).to be_a Subscription
  #   end
  # end
end
