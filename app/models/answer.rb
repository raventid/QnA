class Answer < ActiveRecord::Base
  include Attachable

  belongs_to :question
  belongs_to :user

  default_scope { order(best: 'DESC') }
  
  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :body, presence: true

  def best_answer
    current_best = self.question.best_answer
    current_best.update!(best: false) if current_best
    self.update!(best: true)
  end
end
