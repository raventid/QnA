require_relative '../api_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /profiles/me' do
    let(:method) { :get }
    let(:path) { me_api_v1_profiles_path }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:checked_user) { me }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      before { json_request(method, path, access_token: access_token.token) }

      it_behaves_like 'API profilable'
    end
  end

  describe 'GET /profiles' do
    let(:method) { :get }
    let(:path) { api_v1_profiles_path }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:checked_user) { users.first }

      before { json_request(method, path, access_token: access_token.token) }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'contains a list of users' do
        expect(response.body).to be_json_eql(users.to_json).at_path('profiles')
      end

      it 'does not containt requesting user' do
        expect(response.body).not_to include_json(me.to_json)
      end

      it_behaves_like 'API profilable', 'profiles/0/'
    end
  end
end