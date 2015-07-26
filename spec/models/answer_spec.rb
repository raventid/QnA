require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  
  it { should belong_to :question }
  it { should belong_to :user }

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
end
