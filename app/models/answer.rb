class Answer < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  default_scope { order(best: 'DESC') }
  
  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :body, presence: true

  after_create :notify_subscribers
  after_create :create_subscription_for_author

  def best_answer
    current_best = self.question.best_answer
    current_best.update!(best: false) if current_best
    self.update!(best: true)
  end

  private

  def notify_subscribers
    AnswerNoticeJob.perform_later(self)
  end

  def create_subscription_for_author
    Subscription.find_or_initialize_by(user: self.user, question: self.question)
    # unless Subscription.where(user: self.user, question: self.question).first
    #   Subscription.create(user: self.user, question: self.question)
    # end
  end
end
