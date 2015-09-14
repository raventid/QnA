FactoryGirl.define do
  factory :verification do
    provider 'my_provider'
    uid '123234345sdfsdfsdf'
    email
    token { SecureRandom.hex }

    trait :empty_email do
      email nil
    end

    factory :invalid_verification, traits: [:empty_email]
  end
end
