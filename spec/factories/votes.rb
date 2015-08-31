FactoryGirl.define do
  factory :vote do
    value 1
    user nil
  end

  factory :answer_vote, class: 'Vote' do
    user
    votable { |a| a.association(:answer) }
    value 0
  end

end
