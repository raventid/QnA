require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:votable) { create(:question) }
  let!(:vote) { create(:question_vote, user: user, votable: votable) }

  describe '#voted_for?' do
    it 'returns true if votable was voted by user' do
      expect(user.voted_for?(votable)).to be true
    end
  end

  describe '#vote_for' do
    it 'returns vote object for given votable' do
      expect(user.vote_for(votable)).to be
    end
  end
end
