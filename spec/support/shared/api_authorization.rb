shared_examples_for 'API Authenticable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      json_request(method, path)
      expect(response).to have_http_status :unauthorized
    end

    it 'returns 401 status if access_token is invalid' do
      json_request(method, path, access_token: '1234')
      expect(response).to have_http_status :unauthorized
    end
  end
end