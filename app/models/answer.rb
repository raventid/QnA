class Answer < ActiveRecord::Base
  belongs_to :question

  validates :question_id, presence: true
  validates :body, presence: true
end
