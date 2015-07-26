require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:title).is_at_most(150) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  let(:question){ create(:question) }
  let(:answer){ create(:answer, question: question) }

  before { answer.best_answer }

  describe "#best_answer" do
    it 'returns best answer' do
      expect(question.best_answer).to eq answer
    end
  end
end
