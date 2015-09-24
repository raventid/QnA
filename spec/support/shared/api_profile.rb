shared_examples_for 'API profilable' do |path = ''|
  %w(id email created_at updated_at admin).each do |attr|
    it "contains #{attr}" do
      expect(response.body).to be_json_eql(checked_user.send(attr.to_sym).to_json).at_path("#{path}#{attr}")
    end
  end

  %w(password encrypted_password).each do |attr|
    it "does not contain #{attr}" do
      expect(response.body).to_not have_json_path(attr)
    end
  end
end