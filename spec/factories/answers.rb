FactoryGirl.define do
  sequence :body do |n|
    "AnswerFactoryGirlText#{n}"
  end

  factory :answer do
    body "AnswerFactoryGirlText"
    question
    user
  end

  factory :rand_body_answer, class: Answer do
    body
    question
    user
  end

  factory :invalid_answer, class: Answer do
    body nil
    question
    user
  end
end
