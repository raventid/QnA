FactoryGirl.define do
  factory :authorization do
    user
    provider "MyString"
    uid "MyString"

    trait :for_twitter do
      provider 'twitter'
      uid '12345'
    end

    factory :twitter_authorization, traits: [:for_twitter]
  end
end
