require 'rails_helper'

describe Ability do

  subject(:ability) { Ability.new(user) }

  describe "for guest" do
    let(:user) { nil }
    it { should be_able_to :read, :all }
    it { should_not be_able_to :crud, :all}
    it { should_not be_able_to :manage, :all }
  end

  describe "for user" do
    let(:user)     { create(:user) }
    let(:another)  { create(:user) }

    it { should be_able_to :read, :all }
    it { should be_able_to :create, Comment }

    context "question" do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, create(:question, user: user), user: user }
      it { should_not be_able_to :update, create(:question, user: another), user: user }

      it { should be_able_to :destroy, create(:question, user: user), user: user }
      it { should_not be_able_to :destroy, create(:question, user: another), user: user }
    end

    context "answer" do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, create(:answer, user: user), user: user }
      it { should_not be_able_to :update, create(:answer, user: another), user: user }

      it { should be_able_to :destroy, create(:answer, user: user), user: user }
      it { should_not be_able_to :destroy, create(:answer, user: another), user: user }
    end

    context "best answer" do
      let(:question) { create(:question, user: user) }
      let(:answer) { create(:answer, question: question) }
      let(:other_answer) { create(:answer) }

      it { should be_able_to :best, answer  }
      it { should_not be_able_to :best, other_answer }
    end

    context "Attachment" do
      let(:question) { create(:question, user: user) }
      let(:attachment) { create(:attachment, attachable: question) }

      let(:another_question) { create(:question, user: another) }
      let(:another_attachment) { create(:attachment, attachable: another_question) }

      it { should be_able_to :manage, attachment, user: user  }
      it { should_not be_able_to :manage, another_attachment, user: user }
    end

    context "Vote" do
      let(:question) { create(:question) }
      let(:vote) { create(:vote, user: user, votable: question, value: 1) }

      it { should be_able_to :create, Vote }
      it { should be_able_to :destroy, vote, user: user }
    end
  end

  describe "admin" do
    let(:user) { create :user, admin: true }
    it { should be_able_to :manage, :all }
  end
end
