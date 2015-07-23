class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  default_scope { order(best: 'DESC') }
  
  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def best_answer
    current_best = self.question.best_answer
    current_best.update!(best: false) if current_best
    self.update!(best: true)
  end
end
