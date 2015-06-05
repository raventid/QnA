FactoryGirl.define do
  sequence :title do |n|
    "Questionasked#{n}"
  end

  factory :question do
    title "QuestionFactoryGirlTitle"
    body "QuestionFactoryGirlText"
    user
  end

  factory :rand_title_question, class: "Question" do
    title
    body "QuestionFactoryGirlText"
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end

end
