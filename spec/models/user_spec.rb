require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  # authorizations should or should not be dependent :destroy
  it { should have_many(:authorizations) }

  describe '#voted_for?' do
    let(:user) { create(:user) }
    let(:votable) { create(:question) }
    let!(:vote) { create(:question_vote, user: user, votable: votable) }

    it 'returns true if votable was voted by user' do
      expect(user.voted_for?(votable)).to be true
    end
  end

  describe '#vote_for' do
    let(:user) { create(:user) }
    let(:votable) { create(:question) }
    let!(:vote) { create(:question_vote, user: user, votable: votable) }

    it 'returns vote object for given votable' do
      expect(user.vote_for(votable)).to be
    end
  end

  describe '#is_owner_of?' do
    let(:user) { create(:user) }
    let(:votable) { create(:question) }
    let(:votable_of_user) { create(:question, user: user) }

    context 'some votable' do
      it 'returns false' do
        expect(votable.user_id).to_not eq user.id
      end
    end

    context 'his own votable' do
      it 'returns true' do
        expect(votable_of_user.user_id).to eq user.id
      end
    end

  end

  describe '.find_for_ouath' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    context 'user already has authorization' do
      it 'returns existing user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exists' do
        let(:auth) do
          OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email })
        end

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'should create new authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end

    context 'user does not exist' do
      let(:auth) do
        OmniAuth::AuthHash.new(provider: 'facebook', uid: '123', info: { email: 'new@example.com' })
      end

      it 'creates new user' do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it 'fills user email' do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq auth.info.email
      end

      it 'creates authorization for user' do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end

      it 'create authorization with provider and uid' do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end

    context 'provider does not return email' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: {}) }

      it 'does not save user in database' do
        expect { User.find_for_oauth(auth) }.to_not change(User, :count)
      end

      it 'does not save authorization in database' do
        expect { User.find_for_oauth(auth) }.to_not change(Authorization, :count)
      end

      it 'returns new empty user' do
        expect(User.find_for_oauth(auth)).to be_a_new(User)
      end
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }
    it 'should send daily digest to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest
    end
  end
end
