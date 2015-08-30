require 'rails_helper'

RSpec.describe User do 
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  let(:user){ create(:user) }
  let(:votable){ create(:question) }

  before { user.vote_for }

  describe "#voted_for" do
    it "returns true if votable was voted by user" do
      expect(votable).to be question
    end
  end
end